import 'package:flutter/material.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/blocs/uibloc.dart';

class InheritedBloc extends InheritedWidget {
  final TrainsBloc trainsBloc;
  final StationsBloc stationsBloc;
  final UIBloc uiBloc;

  InheritedBloc({this.trainsBloc, this.stationsBloc, this.uiBloc, Widget child})
      : super(child: child) {
    stationsBloc.fromSuggestionStream.listen((suggestion) {
      trainsBloc.updateFrom(suggestion);
    });
    stationsBloc.toSuggestionStream.listen((suggestion) {
      trainsBloc.updateTo(suggestion);
    });
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

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

  static UIBloc uiOf(context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .uiBloc;
  }
}
