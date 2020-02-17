import 'package:flutter/material.dart';
import 'package:trains/data/blocs/frontpanelbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/suggestions/persistentsuggestionsbloc.dart';
import 'package:trains/data/blocs/suggestions/typingsuggestionsbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';

class InheritedBloc extends InheritedWidget {
  static var stationsBloc = StationsBloc();
  static var searchBloc = SearchBloc();
  static var persistentSuggestionsBloc = PersistentSuggestionsBloc(
      allStations: stationsBloc.allStations,
      fromStation: searchBloc.fromStation,
      toStation: searchBloc.toStation);
  static var frontPanelBloc = FrontPanelBloc();
  static var typingSuggestionsBloc = TypingSuggestionsBloc(
      fromList: persistentSuggestionsBloc.fromList,
      toList: persistentSuggestionsBloc.toList,
      allStations: stationsBloc.allStations,
      updateSearch: searchBloc.updateStation,
      frontPanelState: frontPanelBloc.state,
      stationType: searchBloc.stationType);
  static var trainsBloc = TrainsBloc(
      allTrains: searchBloc.allTrains,
      dateTime: searchBloc.dateTime,
      status: searchBloc.status);
  InheritedBloc({@required Widget child}) : super(child: child);

  static Future<void> init() async {
    await stationsBloc.init();
    if (stationsBloc.allStations.value != null &&
        stationsBloc.allStations.value.length > 1) {
      searchBloc.fromStation.add(stationsBloc.allStations.value.elementAt(0));
      searchBloc.toStation.add(stationsBloc.allStations.value.elementAt(1));
      await searchBloc.search();
    }
    trainsBloc.allTrains.listen((_) {}); //allTrains do not provide updates in other BLoCs without this for some reason
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
