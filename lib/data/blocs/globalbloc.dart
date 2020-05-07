import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/data/blocs/appnavigationbloc.dart';
import 'package:trains/data/blocs/schedulebloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/suggestionsbloc.dart';
import 'package:trains/data/blocs/textbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';

class GlobalBloc extends InheritedWidget {
  final stationsBloc = StationsBloc();
  final searchBloc = SearchBloc();
  final trainsBloc = TrainsBloc();
  final scheduleBloc = ScheduleBloc();
  final sizesBloc = SizesBloc();
  final suggestionsBloc = SuggestionsBloc();
  final textBloc = TextBloc();
  final appNavigationBloc = AppNavigationBloc();

  final status = BehaviorSubject.seeded(Status.notFound);

  GlobalBloc({@required Widget child}) : super(child: child) {
    trainsBloc.scheduleDataOutputStream.listen((newData) {
      scheduleBloc.scheduleDataInputStream.add(newData);
    });

    suggestionsBloc.updateCallback(newCallback: (newStation) {
      searchBloc.updateStation(newStation);
      appNavigationBloc.goBack();
    });

    searchBloc.statusOutputStream.mergeWith(
        [trainsBloc.statusOutputStream]).listen((value) => status.add(value));

    searchBloc.dateTime
        .listen((value) => trainsBloc.dateTimeInputStream.add(value));
    searchBloc.allTrains
        .listen((value) => trainsBloc.allTrainsInputStream.add(value));
    searchBloc.fromStation.listen((fromStation) {
      suggestionsBloc.updateFrom(newCode: fromStation.code);
    });
    searchBloc.toStation.listen((toStation) {
      suggestionsBloc.updateTo(newCode: toStation.code);
    });
    searchBloc.stationType
        .listen((type) => suggestionsBloc.updateType(newType: type));

    sizesBloc.outputSizes.listen((newValue) {
      scheduleBloc.inputSizes.add(newValue);
      trainsBloc.inputSizes.add(newValue);
    });

    stationsBloc.init().then((_) {
      if (stationsBloc.allStations.value != null &&
          stationsBloc.allStations.value.length > 1) {
        searchBloc.fromStation.add(stationsBloc.allStations.value.elementAt(0));
        searchBloc.toStation.add(stationsBloc.allStations.value.elementAt(1));
        suggestionsBloc.updateAllStations(
            newStations: stationsBloc.allStations.value);
        searchBloc.search();
      }
    });
  }

  close() {
    status.close();
  }

  static GlobalBloc of(context) {
    return (context.inheritFromWidgetOfExactType(GlobalBloc) as GlobalBloc);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;
}
