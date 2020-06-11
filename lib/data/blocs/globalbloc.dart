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
    stationsBloc.allStations.listen((allStations) {
      searchBloc.allStationsInput.add(allStations);
    });

    trainsBloc.scheduleDataOutput.listen((newData) {
      scheduleBloc.trainsDataInput.add(newData);
    });

    suggestionsBloc.updateCallback(newCallback: (newStation) {
      searchBloc.updateStation(newStation);
      appNavigationBloc.goBack();
    });

    searchBloc.statusOutputStream.mergeWith(
        [trainsBloc.statusOutput]).listen((value) => status.add(value));

    searchBloc.parametersOuput.listen((parameters) {
      scheduleBloc.searchParametersInput.add(parameters);

      suggestionsBloc.updateFrom(newCode: parameters.from?.code);
      suggestionsBloc.updateTo(newCode: parameters.to?.code);

      trainsBloc.dateTimeInput.add(parameters.time);
    });

    searchBloc.allTrains
        .listen((value) => trainsBloc.allTrainsInputStream.add(value));

    searchBloc.stationType
        .listen((type) => suggestionsBloc.updateType(newType: type));

    sizesBloc.outputSizes.listen((newValue) {
      scheduleBloc.sizesInput.add(newValue);
      trainsBloc.inputSizes.add(newValue);
    });

    stationsBloc.init().then((_) {
      if (stationsBloc.allStations.value != null &&
          stationsBloc.allStations.value.length > 1) {
        searchBloc.updateStation(stationsBloc.allStations.value.elementAt(0));

        searchBloc.updateStation(stationsBloc.allStations.value.elementAt(1));

        suggestionsBloc.updateAllStations(
            newStations: stationsBloc.allStations.value);
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
