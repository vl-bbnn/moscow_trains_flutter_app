import 'package:flutter/material.dart';
import 'package:trains/data/blocs/datebloc.dart';
import 'package:trains/data/blocs/fetchbloc.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/blocs/navbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/suggestions/persistentsuggestionsbloc.dart';
import 'package:trains/data/blocs/suggestions/typingsuggestionsbloc.dart';
import 'package:trains/data/blocs/timebloc.dart';
import 'package:trains/data/blocs/trainclassesbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';

class InheritedBloc extends InheritedWidget {
  static final stationsBloc = StationsBloc();
  static final fetchBloc = FetchBloc();
  static final stationTypeBloc = InputTypeBloc();
  static final reqTypeBloc = InputTypeBloc();

  static final searchBloc = SearchBloc(
    stationType: stationTypeBloc.type,
    reqType: reqTypeBloc.type,
    callback: (fromStation, toStation, fromDateTime, dateTimeType) =>
        fetchBloc.search(fromStation, toStation, fromDateTime, dateTimeType),
  );
  static final persistentSuggestionsBloc = PersistentSuggestionsBloc(
    allStationsStream: stationsBloc.allStations,
    fromController: searchBloc.fromStation,
    toController: searchBloc.toStation,
  );
  static final navBloc = NavBloc();
  static final typingSuggestionsBloc = TypingSuggestionsBloc(
      persistentFromList: persistentSuggestionsBloc.fromList,
      persistentToList: persistentSuggestionsBloc.toList,
      allStationsStream: stationsBloc.allStations,
      updateSearch: searchBloc.updateStation,
      pop: navBloc.pop,
      stationType: stationTypeBloc.type);
  static final trainClassesBloc = TrainClassesBloc(trains: fetchBloc.trains);
  static final timeBloc = TimeBloc(updateSearch: searchBloc.updateTime);
  static final dateBloc = DateBloc(updateSearch: searchBloc.updateDate);

  static final trainsBloc = TrainsBloc(
    allTrains:fetchBloc.trains,
      reqType: reqTypeBloc.type,
      targetDateTime: searchBloc.dateTime,
      deselectedTypes: trainClassesBloc.excludedTypes);
  InheritedBloc({ @required Widget child}) : super(child: child);

  static init() async{
    await stationsBloc.init();
    
    if (stationsBloc.allStations.value != null &&
        stationsBloc.allStations.value.length > 1) {
      searchBloc.fromStation.add(stationsBloc.allStations.value.elementAt(0));
      searchBloc.toStation.add(stationsBloc.allStations.value.elementAt(1));
      searchBloc.fetch();
    }
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  // static FetchBloc fetchOf(context) {
  //   return fetchBloc;
  // }

  static NavBloc navOf(context) {
    return navBloc;
  }

  static TrainClassesBloc trainClassesOf(context) {
    return trainClassesBloc;
  }

  static TrainsBloc trainsOf(context) {
    return trainsBloc;
  }

  static StationsBloc stationsOf(context) {
    return stationsBloc;
  }

  static PersistentSuggestionsBloc persistentOf(context) {
    return persistentSuggestionsBloc;
  }

  static TypingSuggestionsBloc typingOf(context) {
    return typingSuggestionsBloc;
  }

  static SearchBloc searchOf(context) {
    return searchBloc;
  }

  static InputTypeBloc stationTypeOf(context) {
    return stationTypeBloc;
  }

  static InputTypeBloc dateTimeTypeOf(context) {
    return reqTypeBloc;
  }

  static TimeBloc timeOf(context) {
    return timeBloc;
  }

  static DateBloc dateOf(context) {
    return dateBloc;
  }
}
