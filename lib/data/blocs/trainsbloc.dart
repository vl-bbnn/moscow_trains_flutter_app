import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/src/helper.dart';

class TrainsBloc {
  final results = BehaviorSubject.seeded(List<Train>());

  final BehaviorSubject<Status> status;
  final BehaviorSubject<DateTime> dateTime;
  final BehaviorSubject<List<Train>> allTrains;
  var trains = List<Train>();

  TrainsBloc(
      {@required this.status,
      @required this.dateTime,
      @required this.allTrains}) {
    status.listen((newStatus) {
      if (newStatus != Status.found) results.add(List<Train>());
    });
    allTrains.listen((newTrains) {
      _trimTrains(newTrains);
    });
    dateTime.listen((newDateTime) {
      _trimTrains(trains);
    });
  }

  _trimTrains(List<Train> list) {
    if (list.first.departure.isBefore(dateTime.value)) {
      final index =
          list.indexWhere((train) => train.departure.isAfter(dateTime.value));
      if (index >= 0) {
        final newList = list.sublist(index);
        trains = newList;
      } else
        status.add(Status.notFound);
    } else
      trains = list;
    _updateResults();
  }

  _setWarnings() {
    final list = results.value;
    list.asMap().forEach((index, train) {
      train.timeDiffToPrevTrain = index > 0
          ? Helper.timeDiffInMins(
              train.departure, list.elementAt(index - 1).departure)
          : 0;
      train.timeDiffToTarget =
          Helper.timeDiffInMins(train.departure, dateTime.value);
      if (index == list.length - 1) train.isLast = true;
    });
    results.add(list);
  }

  _updateResults() {
    if (trains.isNotEmpty) {
      results.add(trains);
      _setWarnings();
      if (status.value != Status.found) status.add(Status.found);
    } else
      status.add(Status.notFound);
  }

  close() {
    results.close();
    status.close();
    dateTime.close();
  }
}
