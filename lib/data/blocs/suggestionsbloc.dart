import 'package:flutter/widgets.dart';
import 'dart:math';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/common/helper.dart';

class SuggestionsBloc {
  var _stationType;
  var _currentFromStationCode;
  var _currentToStationCode;
  var _allStations = List<Station>();
  var _availableStations = List<Station>();

  var fromList = List<Station>();
  var toList = List<Station>();
  Function(Station newStation) _selectStation;

  final textfield = TextEditingController();
  final focusNode = FocusNode();

  final suggestions = BehaviorSubject.seeded(List<Station>());
  final notEmptyQuery = BehaviorSubject.seeded(false);

  SuggestionsBloc() {
    textfield.addListener(() {
      // print("textfield");
      notEmptyQuery.add(textfield.text.isNotEmpty);
      search();
    });
  }

  updateCallback({newCallback}) {
    // print("update callback");
    _selectStation = newCallback;
  }

  updateFrom({newCode}) {
    // print("update from");
    _currentFromStationCode = newCode;
    _updateInitialSuggestions();
  }

  updateTo({newCode}) {
    // print("update to");
    _currentToStationCode = newCode;
    _updateInitialSuggestions();
  }

  updateType({newType}) {
    // print("update type");
    _stationType = newType;
    search();
  }

  updateAllStations({newStations}) {
    // print("update all stations");
    _allStations = newStations;
    _updateInitialSuggestions();
  }

  _updateInitialSuggestions() {
    // print("update initial suggestions");
    _availableStations = _allStations
        .where((station) =>
            station.code != _currentFromStationCode &&
            station.code != _currentToStationCode)
        .toList();
    if (_availableStations.isNotEmpty) {
      select(6);
      search();
    }
  }

  select(int limit) {
    final rnd = Random();
    final available =
        List.generate(_availableStations.length, (index) => index);
    final used = List();

    index() {
      final place = rnd.nextInt(available.length);
      final index = available.elementAt(place);
      available.removeAt(place);
      used.add(index);
      return index;
    }

    fromList =
        List.generate(limit ?? 5, (_) => _availableStations.elementAt(index()));

    toList =
        List.generate(limit ?? 5, (_) => _availableStations.elementAt(index()));
  }

  search() {
    // print("search");
    final query = textfield.text.toLowerCase();
    if (query != null && query.isNotEmpty) {
      final typingList = List<Station>();
      final startsList = new List<Station>();
      final containsList = new List<Station>();
      var startsWithTransit = false;
      var containsWithTransit = false;
      var found = false;
      _allStations.forEach((station) {
        final name = station.title.toLowerCase();
        final subtitle = station.subtitle.toLowerCase();
        if (name == query || subtitle == query) {
          updateStation(station);
          found = true;
        } else {
          final hasTransit = station.transitList.isNotEmpty;
          if (name.startsWith(query) ||
              subtitle.startsWith(query) &&
                  (!hasTransit || !startsWithTransit)) {
            startsList.add(station);
            startsWithTransit = hasTransit;
          } else if (name.contains(query) ||
              subtitle.contains(query) &&
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
          typingList.addAll(startsList.sublist(0, min(10, startsList.length)));
      }
      // print("added suggestions");
      suggestions.add(typingList);
    } else
      switch (_stationType) {
        case QueryType.departure:
          // print("added suggestions");
          suggestions.add(fromList);
          break;
        case QueryType.arrival:
          // print("added suggestions");
          suggestions.add(toList);
          break;
      }
  }

  clear() {
    textfield.clear();
  }

  updateStation(Station station) {
    _selectStation(station);
    textfield.clear();
  }

  dispose() {
    textfield.dispose();
    suggestions.close();
    notEmptyQuery.close();
  }
}
