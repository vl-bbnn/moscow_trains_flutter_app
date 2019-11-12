import 'package:flutter/widgets.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/newData/blocs/inputtypebloc.dart';
import 'package:trains/newData/classes/station.dart';
import 'dart:math';

class TypingSuggestionsBloc {
  String _query;
  List<Station> _list;

  final textfield = TextEditingController();
  final scroll = ScrollController();
  final focusNode = FocusNode();
  final typingList = BehaviorSubject<List<Station>>();
  final suggestions = BehaviorSubject<List<Station>>();
  final offset = BehaviorSubject<double>();
  final BehaviorSubject<Function()> pop;
  final void Function(Station) updateSearch;
  final BehaviorSubject<Input> stationType;
  final BehaviorSubject<List<Station>> persistentFromList;
  final BehaviorSubject<List<Station>> persistentToList;

  TypingSuggestionsBloc(
      {@required this.stationType,
      @required this.persistentFromList,
      @required this.persistentToList,
      @required Stream<List<Station>> allStationsStream,
      @required this.updateSearch,
      @required this.pop}) {
    suggestions.add(List<Station>());
    typingList.add(List<Station>());

    typingList.listen((newList) {
      if (newList.isNotEmpty)
        suggestions.add(newList);
      else
        switch (stationType.value) {
          case Input.departure:
            suggestions.add(persistentFromList.value);
            break;
          case Input.arrival:
            suggestions.add(persistentToList.value);
            break;
        }
    });

    allStationsStream.listen((newList) {
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
        final name = station.name.toLowerCase();
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
    pop.value();
    textfield.clear();
  }

  close() {
    textfield.dispose();
    typingList.close();
    offset.close();
  }
}
