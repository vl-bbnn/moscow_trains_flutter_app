import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

enum FrontPanelState { Search, StationSelect }

class FrontPanelBloc {
  final state = BehaviorSubject.seeded(FrontPanelState.Search);
  final stationsPanelHeight = BehaviorSubject.seeded(200.0);
  final searchPanelHeight = BehaviorSubject.seeded(300.0);
  final stationSelectPanelHeight = BehaviorSubject.seeded(500.0);
  final panelMinHeight = BehaviorSubject.seeded(200.0);
  final panelMaxHeight = BehaviorSubject.seeded(500.0);
  final focus = BehaviorSubject<FocusNode>();
  final panelClose = BehaviorSubject<Function()>();
  final panelController = PanelController();
  final panelSlide = BehaviorSubject.seeded(0.0);

  FrontPanelBloc() {
    // panelMinHeight.listen((height) => print("Min: " + height.toString()));
    // panelMaxHeight.listen((height) => print("Max: " + height.toString()));
    stationSelectPanelHeight.listen((height) async {
      // print("Station Select Height: " + height.toString());
      // print("Max Height: " + panelMaxHeight.value.toString());
      if (state.value == FrontPanelState.StationSelect &&
          height != panelMaxHeight.value) {
        final position = height / panelMaxHeight.value;
        // print("Position: " + position.toString());
        if (position < 1) {
          await panelController.animatePanelToPosition(position);
        } else {
          await panelController.animatePanelToPosition(0.99);
        }
        panelMaxHeight.add(height);
        await panelController.open();
      }
    });
    searchPanelHeight.listen((height) {
      if (state.value == FrontPanelState.Search &&
          height != panelMaxHeight.value - panelMinHeight.value + 40) {
        panelMaxHeight.add(panelMinHeight.value - 40 + height);
      }
    });
    stationsPanelHeight.listen((height) {
      if (state.value == FrontPanelState.Search) {
        if (height != panelMinHeight.value - 80)
          panelMinHeight.add(height + 80);
        if (height != panelMaxHeight.value - 40 - searchPanelHeight.value)
          panelMaxHeight.add(height + 40 + searchPanelHeight.value);
      }
    });
    state.listen((newState) {
      // print(newState);
      switch (newState) {
        case FrontPanelState.Search:
          panelClose.add(() {});
          break;
        case FrontPanelState.StationSelect:
          panelClose.add(() async {
            state.add(FrontPanelState.Search);
            _unfocus();
            final newHeight =
                panelMinHeight.value - 80 + searchPanelHeight.value;
            if (newHeight != panelMaxHeight.value) {
              await panelController.hide();
              panelMaxHeight.add(newHeight);
              await panelController.show();
              await panelController.open();
            }
          });
          break;
      }
    });
  }

  _unfocus() {
    focus.value?.unfocus();
    focus.add(null);
  }

  close() {
    state.close();
    focus.close();
    panelClose.close();
    panelMaxHeight.close();
    panelMinHeight.close();
    stationsPanelHeight.close();
    stationSelectPanelHeight.close();
    searchPanelHeight.close();
    panelSlide.close();
  }
}
