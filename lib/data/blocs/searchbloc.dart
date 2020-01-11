import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/classes/station.dart';
import 'inputtypebloc.dart';

class SearchBloc {
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
  }

  switchInputs() {
    Station temp = fromStation.value;
    fromStation.add(toStation.value);
    toStation.add(temp);

    if (fromStation.value == null)
      stationType.sink.add(Input.departure);
    else if (toStation.value == null) stationType.sink.add(Input.arrival);
  }

  BehaviorSubject<Input> stationType;
  BehaviorSubject<Input> reqType;

  fetch() {
    if (fromStation.value != null && toStation != null) {
      callback(fromStation.value, toStation.value, dateTime.value,
          reqType.value);
      return true;
    } else {
      print("Null stations");
      return false;
    }
  }

  final void Function(Station, Station, DateTime, Input) callback;

  SearchBloc(
      {@required this.stationType,
      @required this.callback,
      @required this.reqType}) {
    final now = DateTime.now();
    dateTime.add(now);
  }


  final fromStation = BehaviorSubject<Station>();

  final toStation = BehaviorSubject<Station>();

  final dateTime = BehaviorSubject<DateTime>();

  dispose() {
    fromStation.close();
    toStation.close();
    dateTime.close();
  }
}
