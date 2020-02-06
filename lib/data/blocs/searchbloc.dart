import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/classes/station.dart';
import 'inputtypebloc.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/classes/train.dart';

enum Status { searching, found, notFound }

class SearchBloc {
  SearchBloc({@required this.stationType, @required this.reqType}) {
    allTrains.listen((_) {
      // print(allTrains.value.length.toString() + " trains");
    });
    // dateTime.listen((event) {print(formatDate(event));});
  }

  final fromStation = BehaviorSubject<Station>();
  final toStation = BehaviorSubject<Station>();

  final BehaviorSubject<Input> stationType;
  final BehaviorSubject<Input> reqType;

  final dateTime = BehaviorSubject.seeded(DateTime.now());
  final allTrains = BehaviorSubject.seeded(List<Train>());
  final status = BehaviorSubject.seeded(Status.notFound);

  String formatDate(DateTime date) =>
      DateFormat("yyyy-MM-ddTHH:mm").format(date.toLocal());

  String folderNameFromDate(DateTime date) =>
      DateFormat('dd-MM').format(date.toLocal());

  search() async {
    final list = List<Train>();
    print("Searching");
    status.add(Status.searching);
    final scheduleRef = Firestore.instance
        .collection("schedule")
        .document(folderNameFromDate(dateTime.value))
        .collection("queriesOfTheDate")
        .document(fromStation.value.code + '-' + toStation.value.code);
    print("Firestore path: " + scheduleRef.path);
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
    }
  }

  updateDate(DateTime newDateTime) {
    final now = DateTime.now();
    final date = (newDateTime != null &&
            newDateTime.difference(now).inMinutes.abs() > 20)
        ? newDateTime
        : now;
    final currentDate = dateTime.value ?? now;
    dateTime.add(DateTime(
        date.year, date.month, date.day, currentDate.hour, currentDate.minute));
  }

  updateTime(int hours, int minutes) {
    final now = DateTime.now();
    final currentDate = dateTime.value ?? now;
    dateTime.add(DateTime(
        currentDate.year, currentDate.month, currentDate.day, hours, minutes));
  }

  updateStation(Station station) {
    if (stationType.value == Input.departure) {
      fromStation.add(station);
      stationType.sink.add(Input.arrival);
    } else if (stationType.value == Input.arrival) {
      toStation.add(station);
      stationType.sink.add(Input.departure);
    }
    search();
  }

  switchInputs() {
    Station temp = fromStation.value;
    fromStation.add(toStation.value);
    toStation.add(temp);

    if (fromStation.value == null)
      stationType.sink.add(Input.departure);
    else if (toStation.value == null) stationType.sink.add(Input.arrival);
    search();
  }

  dispose() {
    fromStation.close();
    toStation.close();
    dateTime.close();
  }
}
