import 'package:rxdart/subjects.dart';

enum AppState { Launch, Schedule, StationSelect }
enum PageState { closing, opening }

class AppNavigationBloc {
  final nextAppState = BehaviorSubject.seeded(AppState.Launch);
  final currentAppState = BehaviorSubject.seeded(AppState.Launch);
  final pageValue = BehaviorSubject.seeded(0.0);
  final history = List<AppState>();

  AppNavigationBloc() {
    currentAppState.listen((newAppState) {
      history.insert(0, newAppState);
    });
    nextAppState.add(AppState.Schedule);
  }

  // addPageState(PageState newPageState) {
  //   print("New Page State:  -----------  " + newPageState.toString());
  //   // if (newPageState != pageState.value) {
  //   pageState.add(newPageState);
  //   // }
  // }

  goBack() {
    nextAppState.add(history.elementAt(1));
  }

  // updateAppState(AppState newAppState) {
  //   appState.add(appState.value..insert(0, newAppState));
  //   addPageState(PageState.closing);
  // }

  close() {
    nextAppState.close();
    currentAppState.close();
    pageValue.close();
  }
}
