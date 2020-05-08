import 'dart:async';
import 'dart:core';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/classes/station.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';

enum Status { searching, found, notFound }

class SearchParameters {
  Station from;
  Station to;
  DateTime time;

  SearchParameters({this.from, this.to, this.time});

  @override
  String toString() {
    return "Search: \nFrom " +
        from.toString() +
        "\nTo " +
        to.toString() +
        "\nAt " +
        time.toString();
  }
}

class SearchBloc {
  SearchBloc() {
    renewTimer();
    updateTime(DateTime.now());
  }

  updateTime(DateTime time) {
    final oldParameters = parametersOuput.value;

    final newParameters = SearchParameters(
        from: oldParameters.from, to: oldParameters.to, time: time);

    parametersOuput.add(newParameters);
  }

  updateFrom(Station station) {
    final oldParameters = parametersOuput.value;

    final newParameters = SearchParameters(
        from: station, to: oldParameters.to, time: oldParameters.time);

    parametersOuput.add(newParameters);
  }

  updateTo(Station station) {
    final oldParameters = parametersOuput.value;

    final newParameters = SearchParameters(
        from: oldParameters.from, to: station, time: oldParameters.time);

    parametersOuput.add(newParameters);
  }

  final parametersOuput = BehaviorSubject.seeded(SearchParameters());

  final allStationsInput = BehaviorSubject<List<Station>>();

  final stationType = BehaviorSubject.seeded(QueryType.departure);

  final allTrains = BehaviorSubject.seeded(List<Train>());

  final statusOutputStream = BehaviorSubject.seeded(Status.notFound);

  var _periodicTimer;

  renewTimer() {
    _periodicTimer?.cancel();
    final secondsLeft = 61 - DateTime.now().second;
    Future.delayed(Duration(seconds: secondsLeft), () {
      updateTime(DateTime.now());

      _periodicTimer = Timer.periodic(Duration(minutes: 1), (_) {
        updateTime(DateTime.now());
      });
    });
  }

  String formatDate(DateTime date) =>
      DateFormat("yyyy-MM-ddTHH:mm").format(date.toLocal());

  String folderNameFromDate(DateTime date) =>
      DateFormat('dd-MM').format(date.toLocal());

  Future<void> search() async {
    if (parametersOuput.value.from != null &&
        parametersOuput.value.to != null &&
        parametersOuput.value.time != null) {
      final list = List<Train>();
      statusOutputStream.add(Status.searching);
      final scheduleRef = Firestore.instance
          .collection("schedule")
          .document(folderNameFromDate(parametersOuput.value.time))
          .collection("queriesOfTheDate")
          .document(parametersOuput.value.from.code +
              '-' +
              parametersOuput.value.to.code);
      final doc = await scheduleRef.get();
      if (doc.exists) {
        print("Document found in Firestore");
        doc.data['trains'].forEach((train) {
          final newTrain = Train.fromDynamic(train);
          if (allStationsInput.value != null &&
              allStationsInput.value.isNotEmpty) {
            newTrain.from = findStation(newTrain.from.title);
            newTrain.to = findStation(newTrain.to.title);
          }
          list.add(newTrain);
        });
        allTrains.add(list);
      } else {
        print("Document not found in Firestore path: " +
            scheduleRef.path +
            ".\nMaking a request with URL:");
        var _url =
            'https://us-central1-trains-3a75a.cloudfunctions.net/get_trains?to=${parametersOuput.value.to.code}' +
                '&from=${parametersOuput.value.from.code}&date=${formatDate(parametersOuput.value.time)}';
        print(_url);
        try {
          final response = await http.get(_url);
          if (response.statusCode == 200 && response.body == "true") {
            final doc = await scheduleRef.get();
            if (doc.exists) {
              print("Document loaded from Firestore");
              doc.data['trains'].forEach((train) {
                final newTrain = Train.fromDynamic(train);
                if (allStationsInput.value != null &&
                    allStationsInput.value.isNotEmpty) {
                  newTrain.from = findStation(newTrain.from.title);
                  newTrain.to = findStation(newTrain.to.title);
                }
                list.add(newTrain);
              });
              allTrains.add(list);
            } else {
              print("Document not found again. Error");
              print("Not Found");
              statusOutputStream.add(Status.notFound);
            }
          }
        } catch (error) {
          print(error);
        }
      }
    }
  }

  findStation(String title) {
    return allStationsInput.value.firstWhere(
        (station) => station.title.toLowerCase() == title.toLowerCase());
  }

  updateStation(Station station) {
    if (stationType.value == QueryType.departure) {
      updateFrom(station);

      stationType.sink.add(QueryType.arrival);
    } else if (stationType.value == QueryType.arrival) {
      updateTo(station);

      stationType.sink.add(QueryType.departure);
    }
    search();
  }

  switchInputs() {
    final oldParameters = parametersOuput.value;

    final newParameters = SearchParameters(
        from: oldParameters.to,
        to: oldParameters.from,
        time: oldParameters.time);

    parametersOuput.add(newParameters);

    if (parametersOuput.value.from == null)
      stationType.sink.add(QueryType.departure);
    else if (parametersOuput.value.to == null)
      stationType.sink.add(QueryType.arrival);
    search();
  }

  switchTypes() {
    switch (stationType.value) {
      case QueryType.departure:
        stationType.add(QueryType.arrival);
        break;
      case QueryType.arrival:
        stationType.add(QueryType.departure);
        break;
    }
  }

  dispose() {
    parametersOuput.close();

    // fromStation.close();
    // toStation.close();
    // dateTime.close();

    stationType.close();

    _periodicTimer?.cancel();

    allStationsInput.close();
  }
}
