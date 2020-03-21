import 'package:flutter/material.dart';
import 'package:trains/data/blocs/mainscreenbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';

class GlobalValues extends InheritedWidget {
  final stationsBloc = StationsBloc();
  final searchBloc = SearchBloc();
  final trainsBloc = TrainsBloc();
  final schemeBloc = MainScreenBloc();
  // final persistentSuggestionsBloc = PersistentSuggestionsBloc(
  //     allStations: stationsBloc.allStations,
  //     fromStation: searchBloc.fromStation,
  //     toStation: searchBloc.toStation);
  // final frontPanelBloc = FrontPanelBloc();
  // final typingSuggestionsBloc = TypingSuggestionsBloc(
  //     fromList: persistentSuggestionsBloc.fromList,
  //     toList: persistentSuggestionsBloc.toList,
  //     allStations: stationsBloc.allStations,
  //     updateSearch: searchBloc.updateStation,
  //     frontPanelState: frontPanelBloc.state,
  //     stationType: searchBloc.stationType);
  GlobalValues({@required Widget child}) : super(child: child);

  Future<void> init() async {
    await stationsBloc.init();
    trainsBloc.init(
        newAllTrains: searchBloc.allTrains,
        newDateTime: searchBloc.dateTime,
        newStatus: searchBloc.status);
    trainsBloc.selected.listen((train) {
      schemeBloc.updateSelectedTrain(train);
    });
    searchBloc.status.listen((status) {
      schemeBloc.updateStatus(status);
    });
    searchBloc.fromStation.listen((fromStation) {
      schemeBloc.updateFrom(fromStation);
    });searchBloc.toStation.listen((toStation) {
      schemeBloc.updateTo(toStation);
    });
    if (stationsBloc.allStations.value != null &&
        stationsBloc.allStations.value.length > 1) {
      searchBloc.fromStation.add(stationsBloc.allStations.value.elementAt(0));
      searchBloc.toStation.add(stationsBloc.allStations.value.elementAt(1));
      await searchBloc.search();
    }
  }

  static GlobalValues of(context) {
    return (context.inheritFromWidgetOfExactType(GlobalValues) as GlobalValues);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
