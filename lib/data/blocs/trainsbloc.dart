import 'dart:async';
import 'dart:math';
import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

enum Status { searching, found, notFound }

class TrainsBloc {
  final elementHeight =
      Constants.TRAINCARD_HEIGHT + Constants.PADDING_REGULAR * 2;
  final offset = BehaviorSubject<double>();

  var scroll = ScrollController();

  final BehaviorSubject<DateTime> targetDateTime;
  final BehaviorSubject<Input> reqType;
  final BehaviorSubject<List<Train>> allTrains;
  final BehaviorSubject<List<TrainType>> deselectedTypes;

  final results = BehaviorSubject.seeded(List<Train>());
  final status = BehaviorSubject.seeded(Status.notFound);

  TrainsBloc(
      {this.allTrains,
      this.deselectedTypes,
      this.targetDateTime,
      this.reqType}) {
    status.listen((newStatus) {
      if (newStatus != Status.found) results.add(List<Train>());
    });
    status.add(Status.notFound);
    deselectedTypes.listen((_) {
      _updateResults();
      reset();
    });
    allTrains.listen((_) {
      _updateResults();
      reset();
    });
    targetDateTime.listen((_) {
      _updateTimesAtStart();
    });
    reset();
  }

  _updateTimesAtStart() {
    final list = allTrains.value;
    var newFirst = 0;
    if (list.isNotEmpty) {
      list.sublist(0, min(3, list.length)).asMap().forEach((index, train) {
        if (index <= newFirst) {
          switch (reqType.value) {
            case Input.departure:
              final diff =
                  Helper.timeDiffInMins(train.departure, targetDateTime.value);
              if (diff < 0)
                newFirst = index + 1;
              else
                train.timeDiff = diff;
              break;
            case Input.arrival:
              final diff =
                  Helper.timeDiffInMins(train.arrival, targetDateTime.value);
              if (diff > 0)
                newFirst = index + 1;
              else
                train.timeDiff = diff;
              break;
          }
        }
      });
      if (newFirst >= list.length) {
        allTrains.add(List<Train>());
        status.add(Status.notFound);
      } else if (newFirst == 0)
        allTrains.add(list);
      else {
        allTrains.add(list.sublist(newFirst));
      }
    }
  }

  _setWarnings() {
    final list = results.value;
    list.asMap().forEach((index, train) {
      switch (reqType.value) {
        case Input.departure:
          final target = index == 0
              ? targetDateTime.value
              : list.elementAt(index - 1).departure;
          train.timeDiff = Helper.timeDiffInMins(train.departure, target);
          break;
        case Input.arrival:
          final target = index == 0
              ? targetDateTime.value
              : list.elementAt(index - 1).arrival;
          train.timeDiff = Helper.timeDiffInMins(train.arrival, target);
          break;
      }
      if (index == list.length - 1) train.isLast = true;
    });
    results.add(list);
  }

  _updateResults() {
    results.add(allTrains.value
        .where((train) => !deselectedTypes.value.contains(train.type))
        .toList());
    _setWarnings();
    if (results.value.isNotEmpty) status.add(Status.found);
  }

  round() {
    final maxOffset = elementHeight * results.value.length;
    var newOffset = (scroll.offset / elementHeight).round() * elementHeight;
    if (newOffset > maxOffset) newOffset = maxOffset;
    if (scroll.hasClients)
      scrollToOffset(newOffset);
    else if (!scroll.hasClients) offset.add(newOffset);
  }

  jumpToOffset(double newOffset) {
    if (newOffset >= 0 && newOffset <= scroll.position.maxScrollExtent) {
      scroll.jumpTo(newOffset);
      offset.add(scroll.offset);
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
      final newOffset = 0.0;
      if (scroll.hasClients)
        scrollToOffset(newOffset);
      else if (!scroll.hasClients) offset.add(newOffset);
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
  }
}
