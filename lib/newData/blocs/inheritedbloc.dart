import 'package:flutter/material.dart';
import 'package:trains/newData/blocs/datebloc.dart';
import 'package:trains/newData/blocs/fetchbloc.dart';
import 'package:trains/newData/blocs/inputtypebloc.dart';
import 'package:trains/newData/blocs/navbloc.dart';
import 'package:trains/newData/blocs/trainsbloc.dart';
import 'package:trains/newData/blocs/searchbloc.dart';
import 'package:trains/newData/blocs/stationsbloc.dart';
import 'package:trains/newData/blocs/suggestions/persistentsuggestionsbloc.dart';
import 'package:trains/newData/blocs/suggestions/typingsuggestionsbloc.dart';
import 'package:trains/newData/blocs/timebloc.dart';
import 'package:trains/newData/blocs/trainclassesbloc.dart';

class InheritedBloc extends InheritedWidget {
  final StationsBloc stationsBloc;
  final FetchBloc fetchBloc;
  final PersistentSuggestionsBloc persistentSuggestionsBloc;
  final TypingSuggestionsBloc typingSuggestionsBloc;
  final InputTypeBloc stationTypeBloc;
  final InputTypeBloc dateTimeTypeBloc;
  final SearchBloc searchBloc;
  final NavBloc navBloc;
  final TrainClassesBloc trainClassesBloc;
  final TrainsBloc trainsBloc;
  final TimeBloc timeBloc;
  final DateBloc dateBloc;

  InheritedBloc({this.dateBloc, 
      this.trainClassesBloc,
      @required this.persistentSuggestionsBloc,
      @required this.stationTypeBloc,
      @required this.dateTimeTypeBloc,
      @required this.searchBloc,
      @required this.fetchBloc,
      @required this.stationsBloc,
      @required this.typingSuggestionsBloc,
      @required this.navBloc,
      @required this.trainsBloc,
      @required this.timeBloc,
      Widget child})
      : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static FetchBloc fetchOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .fetchBloc;
  }

  static NavBloc navOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .navBloc;
  }

  static TrainClassesBloc trainClassesOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .trainClassesBloc;
  }

  static TrainsBloc trainsOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .trainsBloc;
  }

  static StationsBloc stationsOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .stationsBloc;
  }

  static PersistentSuggestionsBloc persistentOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .persistentSuggestionsBloc;
  }

  static TypingSuggestionsBloc typingOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .typingSuggestionsBloc;
  }

  static SearchBloc searchOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .searchBloc;
  }

  static InputTypeBloc stationTypeOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .stationTypeBloc;
  }

  static InputTypeBloc dateTimeTypeOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .dateTimeTypeBloc;
  }

  static TimeBloc timeOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .timeBloc;
  }
  static DateBloc dateOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .dateBloc;
  }
}
