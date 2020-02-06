import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/data/src/constants.dart';

class DateTimeBloc {
  var _datesUpdater;
  var _timeUpdater;
  var _minTimeOffset = 0.0;
  final _minutesPerStep = 15;
  var _oldHours = 0;
  var _oldMinutes = 0;
  final timeWidth = BehaviorSubject.seeded(0.0);
  final timePercent = BehaviorSubject.seeded(0.0);
  final shouldUpdateTime = BehaviorSubject.seeded(true);
  final minDatesOffset = Constants.DATE_WIDTH + 20;
  final datesOffset = BehaviorSubject.seeded(0.0);
  final datesList = BehaviorSubject.seeded(List.generate(
      90, (index) => DateTime.now().add(Duration(days: index + 1))));
  final todayIsSelected = BehaviorSubject.seeded(true);
  var datesScroll = ScrollController(keepScrollOffset: true);
  final dateChangesByTime = BehaviorSubject.seeded(true);

  final void Function(int, int) updateTime;
  final void Function(DateTime) updateDate;

  DateTimeBloc({@required this.updateDate, @required this.updateTime}) {
    // dateChangesByTime.listen((event) => print(event.toString()));

    resetDate();
    setDatesUpdater();
    timeWidth.listen((width) {
      // print("Time Selector Width: " + width.toString());
      _minTimeOffset = width / (24 * 60 / _minutesPerStep);
      if (shouldUpdateTime.value)
        resetTime();
      else
        selectTime(timePercent.value * width);
    });
    resetTime();
    _timeUpdater = Timer.periodic(Duration(seconds: 1), (Timer t) {
      final now = DateTime.now();
      if (shouldUpdateTime.value &&
          (now.hour != _oldHours || now.minute != _oldMinutes)) resetTime();
    });
  }

  selectDate() {
    final newIndex = (datesScroll.offset / minDatesOffset).round();
    final newDate =
        newIndex > 0 ? datesList.value.elementAt(newIndex - 1) : DateTime.now();
    updateDate(newDate);
  }

  Future<void> roundDateSelector() async {
    final newOffset =
        (datesScroll.offset / minDatesOffset).round() * minDatesOffset;
    if (datesScroll.hasClients) await scrollToOffsetDateSelector(newOffset);
    if (!datesScroll.hasClients) datesOffset.add(newOffset);
    selectDate();
  }

  jumpToOffsetDateSelector(double newOffset) {
    if (newOffset >= 0 && newOffset <= datesScroll.position.maxScrollExtent) {
      datesScroll.jumpTo(newOffset);
      datesOffset.add(datesScroll.offset);
      selectDate();
    }
  }

  Future<void> scrollToOffsetDateSelector(double newOffset) async {
    if (newOffset >= 0 && newOffset <= datesScroll.position.maxScrollExtent)
      await Future.delayed(const Duration(milliseconds: 20), () {}).then((s) {
        datesScroll.animateTo(newOffset,
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      });
  }

  resetDate() {
    final now = DateTime.now();
    updateDate(now);
    if (datesScroll.hasClients)
      scrollToOffsetDateSelector(0);
    else if (!datesScroll.hasClients) datesOffset.add(0);
    todayIsSelected.add(true);
  }

  rebuiltDateSelector() {
    datesScroll?.dispose();
    datesScroll =
        ScrollController(initialScrollOffset: datesOffset.value ?? 0.0);
    datesScroll.addListener(() {
      datesOffset.add(datesScroll.offset);
    });
  }

  _updateDatesList() {
    final now = DateTime.now();
    if (now.day == datesList.value.first.day) {
      datesList.value.removeAt(0);
      if (todayIsSelected.value)
        resetDate();
      else {
        final newOffset = datesOffset.value - minDatesOffset;
        if (datesScroll.hasClients)
          scrollToOffsetDateSelector(newOffset);
        else if (!datesScroll.hasClients) datesOffset.add(newOffset);
      }
    }
  }

  void setDatesUpdater() {
    final now = DateTime.now();
    _updateDatesList();
    final seconds =
        (23 - now.hour) * 3600 + (60 - now.minute) * 60 + 60 - now.second;
    print(seconds.toString() + " left till tomorrow");
    _datesUpdater?.cancel();
    _datesUpdater =
        Future.delayed(Duration(seconds: seconds), _updateDatesList());
  }

  _updateTime(hours, minutes) {
    if (hours != _oldHours || minutes != _oldMinutes) {
      updateTime(hours, minutes);
      _oldHours = hours;
      _oldMinutes = minutes;
    }
  }

  selectTime(newOffset) {
    if (newOffset >= 0 &&
        newOffset <= timeWidth.value &&
        timeWidth.value != 0 &&
        _minTimeOffset != 0) {
      final correctedOffset =
          (newOffset / _minTimeOffset).round() * _minTimeOffset;
      timePercent.add(correctedOffset / timeWidth.value);
      if (timePercent.value == 1.0) {
        if (dateChangesByTime.value) {
          dateChangesByTime.add(false);
          scrollToOffsetDateSelector(datesOffset.value + minDatesOffset);
          _updateTime(24, 0);
        } else
          _updateTime(0, 0);
      } else {
        final newValue = timePercent.value * 24;
        final hours = newValue.floor();
        final minutes = ((newValue - hours) * (60 / _minutesPerStep)).floor() *
            _minutesPerStep;
        _updateTime(hours, minutes);
      }
    }
  }

  resetTime() {
    final now = DateTime.now();
    if (_minTimeOffset != 0) {
      final newOffset = (now.hour * 60 / _minutesPerStep +
              (now.minute / _minutesPerStep).round()) *
          _minTimeOffset;
      selectTime(newOffset);
    }
    _updateTime(now.hour, now.minute);
    shouldUpdateTime.add(true);
    // print(dateChangesByTime.value);
    if (!dateChangesByTime.value) {
      resetDate();
    }
    dateChangesByTime.add(true);
  }

  close() {
    datesList.close();
    datesScroll.dispose();
    datesOffset.close();
    _datesUpdater?.cancel();
    dateChangesByTime.close();
    timeWidth.close();
    _timeUpdater?.cancel();
    shouldUpdateTime.close();
    timePercent.close();
  }
}
