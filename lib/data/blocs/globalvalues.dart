import 'package:flutter/material.dart';
import 'package:trains/data/blocs/appnavigationbloc.dart';
import 'package:trains/data/blocs/mainscreenbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/suggestionsbloc.dart';
import 'package:trains/data/blocs/textbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';

class GlobalValues extends InheritedWidget {
  final stationsBloc = StationsBloc();
  final searchBloc = SearchBloc();
  final trainsBloc = TrainsBloc();
  final scheduleBloc = MainScreenBloc();
  final suggestionsBloc = SuggestionsBloc();
  final textBloc = TextBloc();
  final appNavigationBloc = AppNavigationBloc();

  GlobalValues({@required Widget child}) : super(child: child);

  Future<void> init() async {
    await stationsBloc.init();
    trainsBloc.nextTrain.listen((train) {
      scheduleBloc.updateNextTrain(train);
    });
    trainsBloc.currentTrain.listen((train) {
      scheduleBloc.updateCurrentTrain(train);
    });
    trainsBloc.curvedValue.listen((value) {
      scheduleBloc.updateCurvedValue(newCurvedValue: value);
    });
    trainsBloc.init(
        newAllTrains: searchBloc.allTrains,
        newDateTime: searchBloc.dateTime,
        newStatus: searchBloc.status);
    suggestionsBloc.updateCallback(newCallback: (newStation) {
      searchBloc.updateStation(newStation);
      appNavigationBloc.goBack();
    });
    searchBloc.dateTime.listen((newDateTime) {
      scheduleBloc.updateCurrentTime(newDateTime);
    });
    searchBloc.fromStation.listen((fromStation) {
      scheduleBloc.updateFrom(fromStation);
      suggestionsBloc.updateFrom(newCode: fromStation.code);
    });
    searchBloc.toStation.listen((toStation) {
      scheduleBloc.updateTo(toStation);
      suggestionsBloc.updateTo(newCode: toStation.code);
    });
    searchBloc.stationType.listen((type) {
      suggestionsBloc.updateType(newType: type);
    });
    if (stationsBloc.allStations.value != null &&
        stationsBloc.allStations.value.length > 1) {
      searchBloc.fromStation.add(stationsBloc.allStations.value.elementAt(0));
      searchBloc.toStation.add(stationsBloc.allStations.value.elementAt(1));
      await searchBloc.search();
    }
    suggestionsBloc.updateAllStations(
        newStations: stationsBloc.allStations.value);
  }

  static GlobalValues of(context) {
    return (context.inheritFromWidgetOfExactType(GlobalValues) as GlobalValues);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
