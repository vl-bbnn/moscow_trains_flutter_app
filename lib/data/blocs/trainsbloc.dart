import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';

class TrainsBloc {
  BehaviorSubject<Status> status;
  BehaviorSubject<DateTime> dateTime;
  BehaviorSubject<List<Train>> allTrains;

  var trains = List<Train>();
  final results = BehaviorSubject.seeded(List<Train>());
  final index = BehaviorSubject.seeded(0);
  final nextTrain = BehaviorSubject<Train>();
  final currentTrain = BehaviorSubject<Train>();
  final curvedValue = BehaviorSubject.seeded(0.0);
  Train _prev;
  Train _next;

  init({newStatus, newDateTime, newAllTrains}) {
    status = newStatus;
    dateTime = newDateTime;
    allTrains = newAllTrains;
    status.listen((newStatus) {
      if (newStatus != Status.found) results.add(List<Train>());
    });
    allTrains.listen((newTrains) {
      if (newTrains.isNotEmpty) _trimTrains(newTrains);
    });
    dateTime.listen((newDateTime) {
      if (trains.isNotEmpty) _trimTrains(trains);
    });
  }

  TrainsBloc() {
    index.listen((newIndex) {
      if (results.value.isNotEmpty) {
        _prev = newIndex > 0 ? results.value.elementAt(newIndex - 1) : null;
        currentTrain.add(results.value.elementAt(newIndex));
        _next = newIndex < results.value.length - 1
            ? results.value.elementAt(newIndex + 1)
            : null;
        // nextTrain.add(_next);
      }
    });
    results.listen((newTrains) {
      if (currentTrain.value != null) {
        final newIndex =
            newTrains.indexWhere((train) => train.uid == currentTrain.value.uid);
        if (newIndex > 0)
          index.add(newIndex);
        else
          index.add(0);
      } else
        index.add(0);
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
    } else {
      trains = list;
    }
    if (trains.isNotEmpty) {
      results.add(trains);
      if (status.value != Status.found) status.add(Status.found);
    } else if (status.value != Status.notFound) status.add(Status.notFound);
  }

  updatePage(double newPage) {
    final oldIndex = index.value;
    final newIndex = newPage.round();
    final value = (newPage - oldIndex).abs().clamp(0.0, 1.0);
    curvedValue.add(Curves.linear.transform(value));
    if ((newPage - newIndex).abs() <= 0.01) {
      if (newIndex >= 0 && newIndex <= results.value.length - 1)
        index.add(newIndex);
    } else {
      final newTrain = newPage < oldIndex ? _prev : _next;
      if (newTrain != null) {
        nextTrain.add(newTrain);
      }
    }
  }

  close() {
    results.close();
    status.close();
    dateTime.close();
    nextTrain.close();
    index.close();
  }
}
