import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/frontpanelbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'dart:math';
import 'package:trains/data/classes/station.dart';

//Suggestions will be reworked soon

class TypingSuggestionsBloc {
  final BehaviorSubject<List<Station>> fromList;
  final BehaviorSubject<List<Station>> toList;
  final BehaviorSubject<Input> stationType;
  final BehaviorSubject<List<Station>> allStations;
  final BehaviorSubject<FrontPanelState> frontPanelState;
  final void Function(Station) updateSearch;
  String _query;
  var _list = List<Station>();

  final textfield = TextEditingController();
  final scroll = ScrollController();
  final focusNode = FocusNode();
  final typingList = BehaviorSubject.seeded(List<Station>());
  final suggestions = BehaviorSubject.seeded(List<Station>());
  final offset = BehaviorSubject<double>();

  TypingSuggestionsBloc(
      {@required this.stationType,
      @required this.allStations,
      @required this.fromList,
      @required this.frontPanelState,
      @required this.updateSearch,
      @required this.toList}) {
    typingList.listen((newList) {
      if (newList.isNotEmpty)
        suggestions.add(newList);
      else
        switch (stationType.value) {
          case Input.departure:
            suggestions.add(fromList.value);
            break;
          case Input.arrival:
            suggestions.add(toList.value);
            break;
        }
    });

    allStations.listen((newList) {
      _list = newList;
      search();
    });

    textfield.addListener(() {
      _query = textfield.text.toLowerCase();
      search();
    });

    scroll.addListener(() => offset.add(scroll.offset));
  }

  search() {
    if (_query != null && _query.isNotEmpty) {
      typingList.add(List<Station>());
      final startsList = new List<Station>();
      final containsList = new List<Station>();
      var startsWithTransit = false;
      var containsWithTransit = false;
      var found = false;
      _list.forEach((station) {
        final name = station.title.toLowerCase();
        final subtitle = station.subtitle.toLowerCase();
        if (name == _query || subtitle == _query) {
          updateStation(station);
          found = true;
        } else {
          final hasTransit = station.transitList.isNotEmpty;
          if (name.startsWith(_query) ||
              subtitle.startsWith(_query) &&
                  (!hasTransit || !startsWithTransit)) {
            startsList.add(station);
            startsWithTransit = hasTransit;
          } else if (name.contains(_query) ||
              subtitle.contains(_query) &&
                  (!hasTransit || !containsWithTransit)) {
            containsList.add(station);
            containsWithTransit = hasTransit;
          }
        }
      });
      if (!found) {
        startsList.addAll(containsList.where((station) {
          final hasTransit = station.transitList.isNotEmpty;
          return !startsWithTransit || !hasTransit;
        }));
        if (startsList.length == 1) {
          updateStation(startsList.first);
        } else if (startsList.length > 1)
          typingList.add(startsList.sublist(0, min(10, startsList.length)));
      }
    } else {
      typingList.add(List<Station>());
    }
  }

  clear() {
    textfield.clear();
  }

  updateStation(Station station) {
    updateSearch(station);
    typingList.add(List<Station>());
    frontPanelState.add(FrontPanelState.Search);
    textfield.clear();
  }

  close() {
    textfield.dispose();
    typingList.close();
    offset.close();
  }
}
