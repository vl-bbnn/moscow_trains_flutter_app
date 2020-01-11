import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/data/src/constants.dart';

class DateBloc {
  var periodicTimer;
  var oneTimeTimer;

  final elementWidth = Constants.DATECARD_WIDTH;
  final offset = BehaviorSubject<double>();
  final selected = BehaviorSubject<DateTime>();
  final list = BehaviorSubject<List<DateTime>>();
  final timerShouldUpdate = BehaviorSubject<bool>();

  var scroll = ScrollController(keepScrollOffset: true);

  final void Function(DateTime) updateSearch;

  DateBloc({@required this.updateSearch}) {
    final now = DateTime.now();
    list.add(List.generate(90, (index) => now.add(Duration(days: index + 1))));
    list.value.add(null);
    scroll.addListener(() {
      offset.add(scroll.offset);
      update();
    });
    reset();
    _timer();
    timerShouldUpdate.add(true);
  }

  update() {
    final newIndex = (scroll.offset / elementWidth).round();
    final newDate =
        newIndex > 0 ? list.value.elementAt(newIndex - 1) : DateTime.now();
    selected.add(newDate);
    updateSearch(newDate);
  }

  round() {
    final newOffset = (scroll.offset / elementWidth).round() * elementWidth;
    if (scroll.hasClients) scrollToOffset(newOffset);
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
    updateSearch(now);
    if (scroll.hasClients)
      scrollToOffset(0);
    else if (!scroll.hasClients) offset.add(0);
    selected.add(now);
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

  close() {
    list.close();
    selected.close();
    scroll.dispose();
    offset.close();
    periodicTimer?.cancel();
    oneTimeTimer?.cancel();
    timerShouldUpdate.close();
  }
}
