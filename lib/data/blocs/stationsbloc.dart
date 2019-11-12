import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/src/distance.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/suggestion.dart';

enum InputType { from, to }

class StationsBloc {
  updateStation(Station suggestion) {
    if (_type == InputType.from) {
      fromSuggestionSink.add(suggestion);
      _from = suggestion;
    } else if (_type == InputType.to) {
      toSuggestionSink.add(suggestion);
      _to = suggestion;
    }
    switchInputType();
  }

  switchInputType() {
    if (_type == InputType.from) {
      inputSink.add(InputType.to);
    } else if (_type == InputType.to) {
      inputSink.add(InputType.from);
    }
  }

  InputType _type;

  StationsBloc() {
    _from = new Station();
    _to = new Station();
    _allStations = new List<Station>();
    _userLocation = GeoPoint(0, 0);
    _persistentSuggestions = new List<Station>();
    _typingSuggestions = new List<Station>();
    _closestSuggestion = new Station();
    _passedStations = new Map();
    textStream.listen((text) {
      _updateSuggestions(text);
    });
    inputStream.listen((type) => _type = type);
  }

  init() async {
    await _loadStations();
    await _updateClosestSuggestion();
    if (_persistentSuggestions.length == 0) _updatePersistentSuggestions();
    inputSink.add(InputType.from);
    final secondsLeft = 60 - DateTime.now().second;
    _timer = Timer(Duration(seconds: secondsLeft), () async {
      await _timerUpdates();
      Timer.periodic(const Duration(minutes: 1), (Timer t) async {
        await _timerUpdates();
      });
    });
  }

  _updateSuggestions(String text) {
    _typingSuggestions.clear();
    if (text.isNotEmpty) {
      _allStations.forEach((station) {
        final selectedAsTo =
            _to.station != null ? station.code == _to.station.code : false;
        final selectedAsFrom =
            _from.station != null ? station.code == _from.station.code : false;
        if (_typingSuggestions.length < 2 && !selectedAsFrom && !selectedAsTo) {
          final starts =
              station.name.toLowerCase().startsWith(text.toLowerCase());
          if (starts) {
            _typingSuggestions
                .add(new Station(station: station, text: text));
          }
        }
      });
      if (_typingSuggestions.length == 1)
        updateStation(_typingSuggestions.elementAt(0));
      else {
        if (_closestSuggestion.station != null &&
            _typingSuggestions.length > 0) {
          final indexOfClosest = _typingSuggestions.indexWhere((suggestion) =>
              suggestion.station.name == _closestSuggestion.station.name);
          if (indexOfClosest >= 0)
            _typingSuggestions.elementAt(indexOfClosest).label = Label.closest;
        }
        typingSuggestionsSink.add(_typingSuggestions);
      }
    }
    typingSuggestionsSink.add(_typingSuggestions);
  }

  List<Station> _allStations;
  List<Station> _typingSuggestions;
  List<Station> _persistentSuggestions;
  Map<String, DateTime> _passedStations;
  Station _from;
  Station _to;
  Timer _timer;
  final _closestSuggestionController = BehaviorSubject<Station>();

  Sink<Station> get closestSuggestionSink =>
      _closestSuggestionController.sink;

  Stream<Station> get closestSuggestionStream =>
      _closestSuggestionController.stream;

  Station _closestSuggestion;

  Sink<List<Station>> get typingSuggestionsSink =>
      _typingSuggestionsController.sink;

  Stream<List<Station>> get typingSuggestionsStream =>
      _typingSuggestionsController.stream;
  final _typingSuggestionsController = BehaviorSubject<List<Station>>();

  Sink<List<Station>> get persistentSuggestionsSink =>
      _persistentSuggestionsController.sink;

  Stream<List<Station>> get persistentSuggestionsStream =>
      _persistentSuggestionsController.stream;
  final _persistentSuggestionsController = BehaviorSubject<List<Station>>();

  Sink<InputType> get inputSink => _inputController.sink;

  Stream<InputType> get inputStream => _inputController.stream;
  final _inputController = BehaviorSubject<InputType>();

  Sink<Station> get fromSuggestionSink => _fromSuggestionController.sink;

  Stream<Station> get fromSuggestionStream =>
      _fromSuggestionController.stream;
  final _fromSuggestionController = BehaviorSubject<Station>();

  Sink<Station> get toSuggestionSink => _toSuggestionController.sink;

  Stream<Station> get toSuggestionStream => _toSuggestionController.stream;
  final _toSuggestionController = BehaviorSubject<Station>();

  Sink<String> get textSink => _textController.sink;

  Stream<String> get textStream => _textController.stream;
  final _textController = BehaviorSubject<String>();

  _loadStations() async {
    _allStations.clear();
    final _stationsRef = Firestore.instance
        .collection("stations")
        .orderBy("priority")
        .orderBy("order")
        .reference();
    final _query = await _stationsRef.getDocuments();
    _query.documents.forEach((doc) {
      _allStations.add(Station.fromDocumentSnapshot(doc));
    });
    print("Loaded");
  }

  GeoPoint _userLocation;

  _updateClosestSuggestion() async {
    Station closestStation;
    try {
      var location = new Location();
      var currentLocation = await location.getLocation();
      if (_userLocation.latitude != currentLocation.latitude ||
          _userLocation.longitude != currentLocation.longitude) {
        _userLocation =
            GeoPoint(currentLocation.latitude, currentLocation.longitude);
        var closest = 100000;
        _allStations.forEach((station) {
          final harvesine = new Haversine.fromDegrees(
              latitude1: _userLocation.latitude,
              latitude2: station.location.latitude,
              longitude1: _userLocation.longitude,
              longitude2: station.location.longitude);
          var distance = harvesine.distance().floor();
          if (distance < closest) {
            closest = distance;
            closestStation = station;
          }
        });
        print("Closest station: ${closestStation.name}, distance: $closest");
        if (closest <= 150) {
          _passedStations[closestStation.code] = DateTime.now();
          if (_passedStations.length > 1) {
            //TODO:Firebase Function to get uid of train a user is riding right now
            print(_passedStations);
          }
        }
        if (_closestSuggestion.station != closestStation) {
          _closestSuggestion = new Station(
              station: closestStation,
              label: Label.closest,
              text: closest.toString());
          _updatePersistentSuggestions();
          closestSuggestionSink.add(_closestSuggestion);
        }
      }
    } on Exception catch (e) {
      print(e.toString());
    }
  }

  _timerUpdates() async {
    await _updateClosestSuggestion();
  }

  _updatePersistentSuggestions() {
    _persistentSuggestions.clear();
    _allStations.sublist(0, 9).forEach((station) {
      var closestStationCode = _closestSuggestion.station != null
          ? _closestSuggestion.station.code
          : null;
      if (station.code != closestStationCode) {
        _persistentSuggestions
            .add(new Station(station: station, label: Label.other));
      }
    });
    persistentSuggestionsSink.add(_persistentSuggestions);
  }

  dispose() {
    _timer.cancel();
    _fromSuggestionController.close();
    _toSuggestionController.close();
    _textController.close();
    _typingSuggestionsController.close();
    _inputController.close();
    _closestSuggestionController.close();
    _persistentSuggestionsController.close();
  }
}
