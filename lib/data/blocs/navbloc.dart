import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';

enum NavState { Main, Search, Station, Train }

class NavBloc {
  final state = BehaviorSubject<NavState>();

  final focus = BehaviorSubject<FocusNode>();

  final pop = BehaviorSubject<Function()>();

  NavBloc() {
    state.listen((newState) {
      switch (newState) {
        case NavState.Main:
          pop.add(() {});
          break;
        case NavState.Search:
          pop.add(() {
            state.add(NavState.Main);
          });
          break;
        case NavState.Station:
          pop.add(() {
            _unfocus();
            state.add(NavState.Search);
          });
          break;
        // case NavState.Schedule:
        //   pop.add(() {
        //     state.add(NavState.Search);
        //   });
        //   break;
        case NavState.Train:
          pop.add(() {
            state.add(NavState.Main);
          });
          break;
      }
    });

    state.add(NavState.Main);
  }

  _unfocus() {
    focus.value?.unfocus();
    focus.add(null);
  }

  close() {
    state.close();
    focus.close();
    pop.close();
  }
}
