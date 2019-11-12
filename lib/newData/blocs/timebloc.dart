import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/data/src/constants.dart';

class TimeBloc {
  var periodicTimer;

  final elementHeight =
      Constants.TIMECARD_HEIGHT + Constants.PADDING_REGULAR * 2;
  final offset = BehaviorSubject<double>();
  final selected = BehaviorSubject<DateTime>();
  final list = BehaviorSubject<List<int>>();
  final timerShouldUpdate = BehaviorSubject<bool>();

  var scroll = ScrollController(keepScrollOffset: true);

  final void Function(int, int) updateSearch;

  TimeBloc({@required this.updateSearch}) {
    list.add(List.generate(25, (index) => index % 24));
    scroll.addListener(() {
      offset.add(scroll.offset);
      update();
    });
    reset();
    timerShouldUpdate.add(true);
    _timer();
  }

  update() {
    final percent = scroll.offset / elementHeight;
    final newValue = (percent * 2).round();
    final hours = (newValue / 2).floor();
    final minutes = (newValue % 2) * 30;
    final now = DateTime.now();
    selected.add(DateTime(now.year, now.month, now.day, hours, minutes));
    updateSearch(hours, minutes);
  }

  round() {
    final minOffset = elementHeight / 2;
    final maxOffset = elementHeight * 24;
    var newOffset = (scroll.offset / minOffset).round() * minOffset;
    if (scroll.position.maxScrollExtent - newOffset < minOffset) {
      newOffset = 0.0;
      if (scroll.hasClients) jumpToOffset(newOffset);
    } else if (newOffset == 0) {
      newOffset = maxOffset;
      if (scroll.hasClients) jumpToOffset(newOffset);
    } else if (scroll.hasClients) scrollToOffset(newOffset);
    if (!scroll.hasClients) offset.add(newOffset);
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
            duration: Duration(milliseconds: 300), curve: Curves.easeIn);
      });
  }

  reset() {
    final now = DateTime.now();
    final minimalOffset = elementHeight / 4;
    final newOffset =
        now.hour * elementHeight + (now.minute / 15).round() * minimalOffset;
    if (scroll.hasClients)
      scrollToOffset(newOffset);
    else if (!scroll.hasClients) offset.add(newOffset);
    selected.add(now);
    updateSearch(now.hour, now.minute);
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
    periodicTimer = Timer.periodic(Duration(seconds: 5), (Timer t) {
      if (timerShouldUpdate.value) {
        final now = DateTime.now();
        if (selected.value.hour != now.hour ||
            selected.value.minute != now.minute) reset();
      }
    });
  }

  close() {
    list.close();
    selected.close();
    scroll.dispose();
    offset.close();
    periodicTimer?.cancel();
    timerShouldUpdate.close();
  }
}
