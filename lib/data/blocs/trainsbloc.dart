import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';

enum Selecting { prev, current, next }

class TrainsBloc {
  final dateTimeInputStream = BehaviorSubject<DateTime>();
  final allTrainsInputStream = BehaviorSubject<List<Train>>();

  var trains = List<Train>();

  var index = 0;
  var selecting = Selecting.current;

  final results = BehaviorSubject.seeded(List<Train>());

  final controller = BehaviorSubject<PageController>();
  final valueOutputStream = BehaviorSubject.seeded(0.0);
  final statusOutputStream = BehaviorSubject<Status>();

  final currentTrainOutputStream = BehaviorSubject<Train>();
  final selectedTrainOutputStream = BehaviorSubject<Train>();

  updatePage(double newPage) {
    final newIndex = newPage.round();

    if ((newPage - newIndex).abs() <= 0.01) {
      if (newIndex >= 0 && newIndex <= results.value.length - 1) {
        index = newIndex;
        selecting = Selecting.current;
        currentTrainOutputStream.add(results.value.elementAt(index));
        valueOutputStream.add(0.0);
      }
    } else {
      final value = (newPage - index).abs().clamp(0.0, 1.0);
      final curvedValue = Curves.easeInOut.transform(value);

      if (newPage < index && selecting != Selecting.prev) {
        selectedTrainOutputStream.add(results.value.elementAt(index - 1));
        selecting = Selecting.prev;
      } else if (newPage > index && selecting != Selecting.next) {
        selectedTrainOutputStream.add(results.value.elementAt(index + 1));
        selecting = Selecting.next;
      }

      valueOutputStream.add(curvedValue);
    }
  }

  TrainsBloc() {
    allTrainsInputStream.listen((newTrains) {
      if (newTrains.isNotEmpty) _trimTrains(newTrains);
    });
    dateTimeInputStream.listen((newDateTime) {
      if (trains.isNotEmpty && trains.first.departure.isBefore(newDateTime))
        _trimTrains(trains);
    });
    controller.listen((newController) {
      newController.addListener(() => updatePage(newController.page));
    });
    results.listen((newTrains) {
      final oldIndex = index;
      if (currentTrainOutputStream.value != null) {
        final newIndex = newTrains.indexWhere(
            (train) => train.uid == currentTrainOutputStream.value.uid);
        if (newIndex > 0) index = newIndex;
      } else
        index = 0;
      if (controller.value != null &&
          controller.value.hasClients &&
          index != oldIndex) {
        controller.value.animateToPage(index,
            duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
      } else
        updatePage(0.0);
    });
  }

  _trimTrains(List<Train> list) {
    var index = 0;
    if (list.first.departure.isBefore(dateTimeInputStream.value)) {
      index = list.indexWhere(
          (train) => train.departure.isAfter(dateTimeInputStream.value));
      if (index >= 0) {
        final newList = list.sublist(index);
        trains = newList;
      } else
        statusOutputStream.add(Status.notFound);
    } else {
      trains = list;
    }
    if (trains.isNotEmpty) {
      if (controller.value != null && controller.value.hasClients)
        controller.value
            .animateToPage(index,
                duration: Duration(milliseconds: 400), curve: Curves.easeInOut)
            .then((_) => results.add(trains));
      else
        results.add(trains);
      statusOutputStream.add(Status.found);
    } else
      statusOutputStream.add(Status.notFound);
  }

  close() {
    results.close();
    statusOutputStream.close();
    dateTimeInputStream.close();

    controller.close();
    valueOutputStream.close();
  }
}
