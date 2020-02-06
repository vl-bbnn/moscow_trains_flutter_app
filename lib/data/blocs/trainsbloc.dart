import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/classes/trainclassfilter.dart';
import 'package:trains/data/src/helper.dart';

class TrainsBloc {
  final BehaviorSubject<DateTime> dateTime;
  final BehaviorSubject<bool> shouldUpdateTime;
  final BehaviorSubject<Status> status;
  final BehaviorSubject<List<Train>> allTrains;
  final BehaviorSubject<Input> type;

  final classes = BehaviorSubject.seeded(List<TrainClassFilter>());
  final excludedTypes = BehaviorSubject.seeded(List<TrainClass>());
  final results = BehaviorSubject.seeded(List<Train>());
  var trains = List<Train>();
  var oldDateTime = DateTime.now();

  TrainsBloc(
      {@required this.shouldUpdateTime,
      @required this.status,
      @required this.allTrains,
      @required this.dateTime,
      @required this.type}) {
    status.listen((newStatus) {
      print(newStatus);
      if (newStatus != Status.found) results.add(List<Train>());
    });
    allTrains.listen((_) {
      // print("allTrains update: Trimming full list");
      _trimTrains(allTrains.value);
    });
    classes.listen((_) {
      _updateResults();
    });
    dateTime.listen((_) {
      if (shouldUpdateTime.value) {
        // print("dateTime update: Trimming old list");
        _trimTrains(trains);
      }
      oldDateTime = dateTime.value;
    });
  }

  trim() {
    if (dateTime.value.isAfter(oldDateTime)) {
      // print("dateTime update: Trimming old list");
      _trimTrains(trains);
    } else {
      // print("dateTime update: Trimming full list");
      _trimTrains(allTrains.value);
    }
    oldDateTime = dateTime.value;
  }

  _trimTrains(List<Train> list) {
    // print("trim trains");
    final now = DateTime.now();
    switch (type.value) {
      case Input.departure:
        {
          if (list.first.departure.isBefore(dateTime.value)) {
            final index = list
                .indexWhere((train) => train.departure.isAfter(dateTime.value));
            if (index >= 0) {
              final newList = list.sublist(index);
              trains = newList;
            } else
              status.add(Status.notFound);
          } else
            trains = list;
          break;
        }
      case Input.arrival:
        {
          if (list.first.departure.isBefore(now) ||
              list.last.arrival.isAfter(dateTime.value)) {
            final startIndex =
                list.indexWhere((train) => train.departure.isAfter(now));
            final endIndex = list.lastIndexWhere(
                (train) => train.arrival.isBefore(dateTime.value));
            if (startIndex >= 0 && endIndex >= 0 && startIndex <= endIndex) {
              final newList = list.sublist(startIndex, endIndex).reversed;
              trains = newList;
            } else
              status.add(Status.notFound);
          } else
            trains = list;
          break;
        }
    }
    _initClasses();
    _updateResults();
  }

  _setWarnings() {
    // print("set warnings");
    final list = results.value;
    list.asMap().forEach((index, train) {
      switch (type.value) {
        case Input.departure:
          train.timeDiffToPrevTrain = index > 0
              ? Helper.timeDiffInMins(
                  train.departure, list.elementAt(index - 1).departure)
              : 0;
          train.timeDiffToTarget =
              Helper.timeDiffInMins(train.departure, dateTime.value);
          break;
        case Input.arrival:
          train.timeDiffToPrevTrain = index > 0
              ? Helper.timeDiffInMins(
                  train.arrival, list.elementAt(index - 1).arrival)
              : 0;
          train.timeDiffToTarget =
              Helper.timeDiffInMins(train.arrival, dateTime.value);
          break;
      }
      if (index == list.length - 1) train.isLast = true;
    });
    results.add(list);
  }

  _updateResults() {
    // print("update results");
    final newList = trains
        .where((train) => !excludedTypes.value.contains(train.trainClass))
        .toList();
    if (newList.isNotEmpty) {
      results.add(newList);
      _setWarnings();
      if (status.value != Status.found) status.add(Status.found);
    } else
      status.add(Status.notFound);
  }

  _initClasses() {
    // print("init classes");
    if (trains.isEmpty)
      resetClasses();
    else {
      final map = Map<TrainClass, int>();
      trains.forEach((train) {
        if (!map.containsKey(train.trainClass)) {
          map[train.trainClass] = train.price;
        }
      });
      final list = List<TrainClassFilter>();
      map.forEach((type, price) {
        final oldClasses = classes.value
            .where((trainClass) => trainClass.trainClass == type)
            .toList();
        final newClass = TrainClassFilter(trainClass: type, price: price);
        newClass.selected =
            oldClasses.isNotEmpty ? oldClasses.first.selected : true;
        list.add(newClass);
      });
      classes.add(list);
    }
  }

  resetClasses() {
    excludedTypes.add(List<TrainClass>());
    classes.add(List<TrainClassFilter>());
  }

  updateClass(TrainClass type) {
    final types = excludedTypes.value;
    final currentClasses = classes.value;
    if (types.contains(type)) {
      types.remove(type);
      currentClasses
          .firstWhere((trainClass) => trainClass.trainClass == type)
          .selected = true;
    } else if (types.length < currentClasses.length - 1) {
      types.add(type);
      currentClasses
          .firstWhere((trainClass) => trainClass.trainClass == type)
          .selected = false;
    }
    excludedTypes.add(types);
    classes.add(currentClasses);
  }

  close() {
    results.close();
    status.close();
  }
}
