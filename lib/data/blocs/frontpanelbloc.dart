import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum FrontPanelState { Search, StationSelect }

class FrontPanelBloc {
  final state = BehaviorSubject.seeded(FrontPanelState.Search);
  final stationsHeight = BehaviorSubject.seeded(200.0);
  final messageHeight = BehaviorSubject.seeded(300.0);
  final panelMinHeight = BehaviorSubject.seeded(100.0);
  final panelMaxHeight = BehaviorSubject.seeded(500.0);
  final focus = BehaviorSubject<FocusNode>();
  final panelController = PanelController();
  final panelSlide = BehaviorSubject.seeded(0.0);
  final panelPadding = 80.0;
  final scheduleScrollController = BehaviorSubject.seeded(ScrollController());

  FrontPanelBloc() {
    state.listen((newState) async => await _switchPanel());
  }

  Future<void> scrollScheduleTo(newOffset) async {
    final controller = scheduleScrollController.value;
    if (controller.hasClients) {
      await controller.animateTo(newOffset.toDouble(),
          duration: Duration(milliseconds: 500), curve: Curves.easeOut);
    }
  }

  updateMaxHeight(height) {
    if (height != panelMaxHeight.value) {
      panelMaxHeight.add(height);
    }
  }

  updateMinHeight(height) {
    if (height != panelMinHeight.value) {
      panelMinHeight.add(height);
    }
  }

  _switchPanel() async {
    switch (state.value) {
      case FrontPanelState.Search:
        focus.value?.unfocus();
        focus.add(null);
        if (panelController.isAttached) {
          await panelController.show();
        }
        break;
      case FrontPanelState.StationSelect:
        if (panelController.isAttached) await panelController.hide();
        break;
    }
  }

  close() {
    state.close();
    focus.close();
    panelMaxHeight.close();
    panelMinHeight.close();
    stationsHeight.close();
    messageHeight.close();
    panelSlide.close();
    scheduleScrollController.close();
  }
}
