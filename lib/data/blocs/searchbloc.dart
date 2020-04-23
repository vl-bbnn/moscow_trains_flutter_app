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

class SearchBloc {
  SearchBloc() {
    renewTimer();
    status.listen((event) {
    });
  }

  final fromStation = BehaviorSubject<Station>();
  final toStation = BehaviorSubject<Station>();

  final stationType = BehaviorSubject.seeded(QueryType.departure);

  final dateTime = BehaviorSubject.seeded(DateTime.now());
  final allTrains = BehaviorSubject.seeded(List<Train>());
  final status = BehaviorSubject.seeded(Status.notFound);

  var _periodicTimer;

  renewTimer() {
    _periodicTimer?.cancel();
    final secondsLeft = 61 - DateTime.now().second;
    Future.delayed(Duration(seconds: secondsLeft), () {
      dateTime.add(DateTime.now());
      _periodicTimer = Timer.periodic(Duration(minutes: 1), (_) {
        dateTime.add(DateTime.now());
      });
    });
  }

  String formatDate(DateTime date) =>
      DateFormat("yyyy-MM-ddTHH:mm").format(date.toLocal());

  String folderNameFromDate(DateTime date) =>
      DateFormat('dd-MM').format(date.toLocal());

  Future<void> search() async {
    final list = List<Train>();
    status.add(Status.searching);
    final scheduleRef = Firestore.instance
        .collection("schedule")
        .document(folderNameFromDate(dateTime.value))
        .collection("queriesOfTheDate")
        .document(fromStation.value.code + '-' + toStation.value.code);
    final doc = await scheduleRef.get();
    if (doc.exists) {
      print("Document found in Firestore");
      doc.data['trains'].forEach((train) => list.add(Train.fromDynamic(train)));
      allTrains.add(list);
    } else {
      print("Document not found in Firestore path: " +
          scheduleRef.path +
          ".\nMaking a request with URL:");
      var _url =
          'https://us-central1-trains-3a75a.cloudfunctions.net/get_trains?to=${toStation.value.code}' +
              '&from=${fromStation.value.code}&date=${formatDate(dateTime.value)}';
      print(_url);
      try {
        final response = await http.get(_url);
        if (response.statusCode == 200 && response.body == "true") {
          final doc = await scheduleRef.get();
          if (doc.exists) {
            print("Document loaded from Firestore");
            doc.data['trains']
                .forEach((train) => list.add(Train.fromDynamic(train)));
            allTrains.add(list);
          } else {
            print("Document not found again. Error");
            print("Not Found");
            status.add(Status.notFound);
          }
        }
      } catch (error) {
        print(error);
      }
    }
  }

  updateStation(Station station) {
    if (stationType.value == QueryType.departure) {
      fromStation.add(station);
      stationType.sink.add(QueryType.arrival);
    } else if (stationType.value == QueryType.arrival) {
      toStation.add(station);
      stationType.sink.add(QueryType.departure);
    }
    search();
  }

  switchInputs() {
    Station temp = fromStation.value;
    fromStation.add(toStation.value);
    toStation.add(temp);

    if (fromStation.value == null)
      stationType.sink.add(QueryType.departure);
    else if (toStation.value == null) stationType.sink.add(QueryType.arrival);
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
    fromStation.close();
    toStation.close();
    dateTime.close();
    stationType.close();
    _periodicTimer?.cancel();
  }
}
