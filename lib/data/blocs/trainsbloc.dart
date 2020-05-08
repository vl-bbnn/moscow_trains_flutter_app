import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/train.dart';

enum Selecting { prev, current, next }

class TrainsData {
  final Train currentTrain;
  final Train nextTrain;

  final double totalValue;
  final double collapseValue;
  final double moveValue;
  final double expandValue;

  TrainsData(
      {this.currentTrain,
      this.nextTrain,
      this.totalValue,
      this.collapseValue,
      this.moveValue,
      this.expandValue});
}

class TrainsBloc {
  final dateTimeInputStream = BehaviorSubject<DateTime>();
  final allTrainsInputStream = BehaviorSubject<List<Train>>();
  final inputSizes = BehaviorSubject<Sizes>();

  Sizes sizes;

  var trains = List<Train>();

  final results = BehaviorSubject.seeded(List<Train>());

  final controller = ScrollController();
  final scheduleDataOutputStream = BehaviorSubject<TrainsData>();
  final statusOutputStream = BehaviorSubject<Status>();

  double startOffset = 0.0;

  double collapsePercent = 0.25;
  double movePercent = 0.5;
  double expandPercent = 0.25;

  double trainOffset = 0.0;

  int currentIndex = 0;
  int nextIndex = 1;

  dragStart() {
    startOffset = controller.offset;
  }

  double dragUpdate(double delta) {
    if (sizes != null) {
      currentIndex = (startOffset / trainOffset)
          .round()
          .clamp(0, results.value.length - 1);

      nextIndex = ((startOffset - trainOffset * delta.sign) / trainOffset)
          .round()
          .clamp(0, results.value.length - 1);

      final endOffset = nextIndex * trainOffset;

      final percent = endOffset != startOffset
          ? (delta / (endOffset - startOffset).abs())
          : 0.0;

      dragPercent(percent);

      return percent;
    } else
      return 0.0;
  }

  dragPercent(double percent) {
    if (results.value != null && results.value.length > 0) {
      final currentTrain = results.value.elementAt(currentIndex);

      final nextTrain = results.value.elementAt(nextIndex);

      final totalValue = percent.abs();

      final collapseValue =
          (percent.abs().clamp(0.0, collapsePercent)) / collapsePercent;

      final moveValue =
          (percent.abs() - collapsePercent).clamp(0.0, movePercent) /
              movePercent;

      final newOffset = startOffset - moveValue * trainOffset * percent.sign;
      if (newOffset > -trainOffset * 0.25 && controller.hasClients)
        controller.jumpTo(newOffset);

      final expandValue = (percent.abs() - collapsePercent - movePercent)
              .clamp(0.0, expandPercent) /
          expandPercent;

      final newScheduleData = TrainsData(
          currentTrain: currentTrain,
          nextTrain: nextTrain,
          totalValue: totalValue,
          collapseValue: collapseValue,
          moveValue: moveValue,
          expandValue: expandValue);

      scheduleDataOutputStream.add(newScheduleData);
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

    inputSizes.listen((newSizes) {
      sizes = newSizes;
      trainOffset =
          sizes.regularTrain.cardWidth + 2 * sizes.regularTrain.outerPadding;
    });
  }

  _trimTrains(List<Train> list) {
    final dateTime = dateTimeInputStream.value ?? DateTime.now();

    if (list.first.departure.isBefore(dateTime)) {
      final index =
          list.indexWhere((train) => train.departure.isAfter(dateTime));

      if (index > 0) {
        trains = list.sublist(index);

        statusOutputStream.add(Status.found);

        results.add(trains);
      } else
        statusOutputStream.add(Status.notFound);
    } else {
      trains = list;

      statusOutputStream.add(Status.found);

      results.add(trains);

      dragPercent(0.0);
    }
  }

  close() {
    results.close();
    statusOutputStream.close();
    dateTimeInputStream.close();
    inputSizes.close();

    scheduleDataOutputStream.close();
  }
}
