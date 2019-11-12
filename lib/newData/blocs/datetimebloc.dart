import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

enum DateTimeType { Hours, Minutes, Dates }

class DateTimeBloc {
  var periodicTimer;
  var oneTimeTimer;
  var elementWidth = 0.0;
  var elementHeight = 0.0;

  final nextMonth = BehaviorSubject<int>();
  final prevMonth = BehaviorSubject<int>();

  final index = BehaviorSubject<int>();
  final offset = BehaviorSubject<double>();
  final selected = BehaviorSubject<dynamic>();
  final list = BehaviorSubject<List<dynamic>>();
  final timerShouldUpdate = BehaviorSubject<bool>();

  var scroll = ScrollController(keepScrollOffset: true);

  final type;
  final void Function(DateTimeType, dynamic) updateSearch;

  DateTimeBloc({@required this.updateSearch, @required this.type}) {
    final now = DateTime.now();
    switch (type) {
      case DateTimeType.Hours:
        list.add(List.generate(24, (index) => index));
        elementWidth = Constants.TIMECARD_WIDTH;
        elementHeight = Constants.TIMECARD_HEIGHT;
        break;
      case DateTimeType.Minutes:
        list.add(List.generate(12, (index) => index * 5));
        elementWidth = Constants.TIMECARD_WIDTH;
        elementHeight = Constants.TIMECARD_HEIGHT;
        break;
      case DateTimeType.Dates:
        list.add(List.generate(90, (index) => now.add(Duration(days: index))));
        elementWidth = Constants.DATECARD_WIDTH;
        elementHeight = Constants.DATECARD_HEIGHT;
        break;
    }
    index.listen((newIndex) {
      selected.add(list.value.elementAt(newIndex));
      if (type == DateTimeType.Dates) _updateMonthIndexes();
    });
    scroll.addListener(() {
      offset.add(scroll.offset);
    });
    nextMonth.add(-1);
    prevMonth.add(-1);
    reset();
    _timer();
    timerShouldUpdate.add(true);
  }

  update(int newIndex) {
    index.add(newIndex);
    final newValue = list.value.elementAt(newIndex);
    updateSearch(type, newValue);
  }

  scrollToIndex(int newIndex) {
    var correctedIndex = newIndex;
    if (correctedIndex < 0) {
      correctedIndex = 0;
    } else if (correctedIndex >= list.value.length) {
      correctedIndex = list.value.length - 1;
    }
    index.add(correctedIndex);
    final offset =
        correctedIndex * (elementWidth + Constants.PADDING_REGULAR * 2);
    scrollToOffset(offset);
  }

  jumpToOffset(double newOffset) {
    if (newOffset >= 0 && newOffset <= scroll.position.maxScrollExtent)
      scroll.jumpTo(newOffset);
  }

  scrollToOffset(double newOffset) {
    if (newOffset >= 0 && newOffset <= scroll.position.maxScrollExtent)
      Future.delayed(const Duration(milliseconds: 20), () {}).then((s) {
        scroll.animateTo(newOffset,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      });
  }

  reset() {
    final now = DateTime.now();
    var newIndex = 0;
    var newOffset = 0.0;
    switch (type) {
      case DateTimeType.Hours:
        newIndex = now.hour;
        updateSearch(type, now.hour);
        index.add(newIndex);
        newOffset = newIndex * (elementWidth + Constants.PADDING_REGULAR * 2);
        if (scroll.hasClients) scrollToIndex(newIndex);
        break;
      case DateTimeType.Minutes:
        updateSearch(type, now.minute);
        selected.add(now.minute);
        newOffset =
            (now.minute / 5) * (elementWidth + Constants.PADDING_REGULAR * 2);
        if (scroll.hasClients) scrollToOffset(newOffset);
        break;
      case DateTimeType.Dates:
        updateSearch(type, DateTime.now());
        if (!Helper.isToday(list.value.first)) list.value.removeAt(0);
        if (scroll.hasClients)
          scrollToIndex(0);
        else {
          index.add(0);
        }
    }
    if (!scroll.hasClients) offset.add(newOffset);
    timerShouldUpdate.add(true);
  }

  rebuilt() {
    scroll?.dispose();
    scroll = ScrollController(initialScrollOffset: offset.value ?? 0.0);
    scroll.addListener(() {
      offset.add(scroll.offset);
    });
  }

  void _timer() {
    var seconds = 60 - DateTime.now().second;
    oneTimeTimer = Future.delayed(Duration(seconds: seconds), () {
      if (timerShouldUpdate.value) reset();
      periodicTimer = Timer.periodic(Duration(minutes: 1), (Timer t) {
        if (timerShouldUpdate.value) reset();
      });
    });
  }

  _updateMonthIndexes() {
    final nextIndex = list.value.sublist(index.value).indexWhere((dateTime) {
      if (dateTime == null) return false;
      return dateTime.month == selected.value.month + 1 ||
          dateTime.month == (selected.value.month + 1) % 12;
    });
    if (nextIndex >= 0)
      nextMonth.add(nextIndex + index.value);
    else
      nextMonth.add(-1);
    final prevIndex =
        list.value.sublist(0, index.value + 1).indexWhere((dateTime) {
      if (dateTime == null) return false;
      return dateTime.month + 1 == selected.value.month ||
          (dateTime.month + 1) % 12 == selected.value.month;
    });
    if (prevIndex >= 0)
      prevMonth.add(prevIndex);
    else
      prevMonth.add(-1);
  }

  close() {
    list.close();
    selected.close();
    scroll.dispose();
    offset.close();
    index.close();
    periodicTimer?.cancel();
    oneTimeTimer?.cancel();
    timerShouldUpdate.close();
    nextMonth.close();
    prevMonth.close();
  }
}
