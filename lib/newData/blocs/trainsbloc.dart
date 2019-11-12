import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/newData/blocs/inputtypebloc.dart';
import 'package:trains/newData/classes/train.dart';

enum Status { searching, found, notFound }

class TrainsBloc {
  final elementHeight =
      Constants.TRAINCARD_HEIGHT + Constants.PADDING_REGULAR * 2;
  final offset = BehaviorSubject<double>();
  final selected = BehaviorSubject.seeded(0);
  final selectedTrain = BehaviorSubject.seeded("");

  var scroll = ScrollController();

  final BehaviorSubject<DateTime> targetDateTime;
  final BehaviorSubject<Input> targetDateTimeType;
  final BehaviorSubject<List<Train>> allTrains;
  final BehaviorSubject<List<TrainType>> deselectedTypes;

  final results = BehaviorSubject.seeded(List<Train>());
  final status = BehaviorSubject<Status>();

  TrainsBloc(
      {this.allTrains,
      this.deselectedTypes,
      this.targetDateTime,
      this.targetDateTimeType}) {
    status.listen((newStatus) {
      if (newStatus != Status.found) results.add(List<Train>());
    });
    status.add(Status.searching);
    deselectedTypes.listen((_) {
      _updateResults();
      reset();
    });
    allTrains.listen((_) {
      if (allTrains.value.isEmpty) {
        results.add(List<Train>());
        status.add(Status.notFound);
      } else
        _updateResults();
      reset();
    });
    selected.listen((newIndex) {
      if (newIndex < results.value.length)
        selectedTrain.add(results.value.elementAt(newIndex).uid);
    });
    targetDateTime.listen((_) {
      _updateTimesAtStart();
      _updateTimesNearSelected();
    });
    reset();
  }

  _updateTimesAtStart() {
    final list = allTrains.value;
    var newFirst = 0;
    if (list.isNotEmpty) {
      list
          .sublist(0, min(10, allTrains.value.length))
          .asMap()
          .forEach((index, train) {
        if (index <= newFirst) {
          train.departureDiff =
              Helper.timeDiffInMins(train.departure, targetDateTime.value) ?? 0;
          train.arrivalDiff =
              Helper.timeDiffInMins(train.arrival, targetDateTime.value) ?? 0;
          if (targetDateTimeType.value == Input.departure &&
                  train.departureDiff < 0 ||
              targetDateTimeType.value == Input.arrival &&
                  train.arrivalDiff > 0) newFirst = index + 1;
        }
      });
    }
    if (newFirst >= list.length) {
      allTrains.add(List<Train>());
      results.add(List<Train>());
      status.add(Status.notFound);
    } else if (newFirst == 0) {
      results.add(list);
    } else {
      final newSelected = max(0, selected.value - newFirst);
      allTrains.add(list.sublist(newFirst));
      _updateResults();
      selected.add(newSelected);
    }
  }

  _updateTimesNearSelected() {
    final list = results.value;
    list.asMap().forEach((index, train) {
      if (index == selected.value) {
        train.departureDiff =
            Helper.timeDiffInMins(train.departure, targetDateTime.value) ?? 0;
        train.arrivalDiff =
            Helper.timeDiffInMins(train.arrival, targetDateTime.value) ?? 0;
      } else {
        train.departureDiff = Helper.timeDiffInMins(
                train.departure, list.elementAt(selected.value).departure) ??
            0;
        train.arrivalDiff = Helper.timeDiffInMins(
                train.arrival, list.elementAt(selected.value).arrival) ??
            0;
      }
    });
    results.add(list);
    selected.add(selected.value);
  }

  _updateResults() {
    results.add(allTrains.value
        .where((train) => !deselectedTypes.value.contains(train.type))
        .toList());
    if (results.value.isNotEmpty) status.add(Status.found);
  }

  update() {
    var index = (scroll.offset / elementHeight).round();
    selected.add(index);
    _updateTimesNearSelected();
  }

  round() {
    final maxOffset = elementHeight * results.value.length;
    var newOffset = (scroll.offset / elementHeight).round() * elementHeight;
    if (newOffset > maxOffset) newOffset = maxOffset;
    if (scroll.hasClients)
      scrollToOffset(newOffset);
    else if (!scroll.hasClients) offset.add(newOffset);
    update();
  }

  jumpToOffset(double newOffset) {
    if (newOffset >= 0 && newOffset <= scroll.position.maxScrollExtent) {
      scroll.jumpTo(newOffset);
      offset.add(scroll.offset);
      update();
    }
  }

  scrollToOffset(double newOffset) {
    if (newOffset >= 0 && newOffset <= scroll.position.maxScrollExtent)
      Future.delayed(const Duration(milliseconds: 20), () {}).then((s) {
        scroll.animateTo(newOffset,
            duration: Duration(milliseconds: 500), curve: Curves.easeIn);
      });
  }

  reset() {
    if (results.value.isNotEmpty) {
      final findIndex =
          results.value.indexWhere((train) => train.uid == selectedTrain.value);
      final newIndex = findIndex >= 0 ? findIndex : 0;
      final newOffset = newIndex * elementHeight;
      if (scroll.hasClients)
        scrollToOffset(newOffset);
      else if (!scroll.hasClients) offset.add(newOffset);
      selected.add(newIndex);
      _updateTimesNearSelected();
    }
  }

  rebuilt() {
    scroll?.dispose();
    scroll = ScrollController(initialScrollOffset: offset.value ?? 0.0);
    scroll.addListener(() {
      offset.add(scroll.offset);
    });
  }

  close() {
    results.close();
    status.close();
    selected.close();
    selectedTrain.close();
  }
}
