import 'package:flutter/material.dart';
import 'package:trains/data/blocs/datetimebloc.dart';
import 'package:trains/data/blocs/frontpanelbloc.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/suggestions/persistentsuggestionsbloc.dart';
import 'package:trains/data/blocs/suggestions/typingsuggestionsbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';

class InheritedBloc extends InheritedWidget {
  static final stationsBloc = StationsBloc();
  static final stationTypeBloc = InputTypeBloc();
  static final reqTypeBloc = InputTypeBloc();
  static final searchBloc = SearchBloc(
    stationType: stationTypeBloc.type,
    reqType: reqTypeBloc.type,
  );
  static final persistentSuggestionsBloc = PersistentSuggestionsBloc(
    allStationsStream: stationsBloc.allStations,
    fromController: searchBloc.fromStation,
    toController: searchBloc.toStation,
  );
  static final frontPanelBloc = FrontPanelBloc();
  static final typingSuggestionsBloc = TypingSuggestionsBloc(
      persistentFromList: persistentSuggestionsBloc.fromList,
      persistentToList: persistentSuggestionsBloc.toList,
      allStationsStream: stationsBloc.allStations,
      updateSearch: searchBloc.updateStation,
      pop: frontPanelBloc.panelClose,
      stationType: stationTypeBloc.type);
  static final dateTimeBloc = DateTimeBloc(
      updateDate: searchBloc.updateDate, updateTime: searchBloc.updateTime);
  static final trainsBloc = TrainsBloc(
      shouldUpdateTime: dateTimeBloc.shouldUpdateTime,
      dateTime: searchBloc.dateTime,
      type: reqTypeBloc.type,
      status: searchBloc.status,
      allTrains: searchBloc.allTrains);

  InheritedBloc({@required Widget child}) : super(child: child);

  static init() async {
    await stationsBloc.init();

    if (stationsBloc.allStations.value != null &&
        stationsBloc.allStations.value.length > 1) {
      searchBloc.fromStation.add(stationsBloc.allStations.value.elementAt(0));
      searchBloc.toStation.add(stationsBloc.allStations.value.elementAt(1));
      await searchBloc.search();
    }
    trainsBloc.allTrains.listen((_) {});
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
