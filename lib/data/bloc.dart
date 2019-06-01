import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/station.dart';
import 'train.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:location/location.dart';
import 'package:flutter/services.dart';

enum InputType { from, to }

class TrainsBloc {
  TrainsBloc() {
    _loadStations().then((_) {
      _stationsSubject.add(_allStations);
    });
//    shown.listen((shown) {
//      print("Listener");
//      shown.forEach((train) async {
//        if (train.thread == null) {
//          print("Pass");
//          train.thread = await fetchThread(train.uid);
//          int _index = _shownTrains.length + 1;
//          int _i = _shownTrains.indexOf(train);
//          if (_i >= 0) {
//            _index = _i;
//            _shownTrains.removeAt(_index);
//          }
//          _shownTrains.insert(_index, train);
//          addShown.add(_shownTrains);
//        }
//      });
//    });
    _suggestionsRows.add(0);
    _fromController.stream.listen((text) {
      if (text.isEmpty) {
        _from = "";
        clearSuggestions();
      } else if (!_from.toLowerCase().contains(text.toLowerCase())) {
        _from = text;
        _updateSuggestions(InputType.from);
      }
    });
    _toController.stream.listen((text) {
      if (text.isEmpty) {
        _to = "";
        clearSuggestions();
      } else if (!_to.toLowerCase().contains(text.toLowerCase())) {
        _to = text;
        _updateSuggestions(InputType.to);
      }
    });
    _isArrivalController.stream.listen((data) {
      isArr = data;
      _fetchData();
    });
    selectedDateStream.listen((newDate) {
      _selectedDate = newDate;
      _fetchData();
    });
    fromStation.listen((station) {
      if (_fromStation != station) {
        _fromStation = station;
        if (_fromStation != null && _toStation != null) _fetchData();
      }
    });
    toStation.listen((station) {
      if (_toStation != station) {
        _toStation = station;
        if (_toStation != null && _fromStation != null) _fetchData();
      }
    });
  }

  List<String> monthsNames = [
    'Январь',
    'Февраль',
    'Март',
    'Апрель',
    'Май',
    'Июнь',
    'Июль',
    'Август',
    'Сентябрь',
    'Октябрь',
    'Ноябрь',
    'Декабрь'
  ];
  List<Station> _allStations = <Station>[];
  final _stationsSubject = BehaviorSubject<List<Station>>();

  Stream<List<Station>> get stations => _stationsSubject.stream;

  Sink<Station> get setFromStation => _fromStationController.sink;

  Stream<Station> get fromStation => _fromStationController.stream;
  final _fromStationController = BehaviorSubject<Station>();

  Sink<Station> get setToStation => _toStationController.sink;

  Stream<Station> get toStation => _toStationController.stream;
  final _toStationController = BehaviorSubject<Station>();

  Stream<int> get suggestionsRows => _suggestionsRowsController.stream;

  Sink<int> get _suggestionsRows => _suggestionsRowsController.sink;
  final _suggestionsRowsController = BehaviorSubject<int>();

  Sink<bool> get isArrival => _isArrivalController.sink;
  final _isArrivalController = BehaviorSubject<bool>();

  Sink<DateTime> get selectedDateSink => _selectedDateController.sink;

  Stream<DateTime> get selectedDateStream => _selectedDateController.stream;
  final _selectedDateController = BehaviorSubject<DateTime>();

  String _from = "";
  String _to = "";
  Station _fromStation = Station("", "");
  Station _toStation = Station("", "");

  Sink<String> get from => _fromController.sink;
  final _fromController = StreamController<String>();

  Sink<String> get to => _toController.sink;
  final _toController = StreamController<String>();

  List<Station> _suggestions = <Station>[];
  final _suggestionsSubjects = BehaviorSubject<List<Station>>();

  Stream<List<Station>> get suggestions => _suggestionsSubjects.stream;

  void _updateSuggestions(InputType type) {
    _suggestions.clear();
    _suggestionsSubjects.add(_suggestions);
    String _primary = "";
    String _secondary = "";
    int _suggestionsSymbols = 0;
    if (type == InputType.from) {
      _primary = _from;
      _secondary = _to;
    }
    if (type == InputType.to) {
      _primary = _to;
      _secondary = _from;
    }
    if (_primary.isNotEmpty)
      _allStations.forEach((station) {
        String _stationName = station.name;
        if (_stationName.toLowerCase().startsWith(_primary.toLowerCase()) &&
            _suggestions.length < 3 &&
            _stationName.toLowerCase() != _primary.toLowerCase() &&
            _stationName.toLowerCase() != _secondary.toLowerCase()) {
          _suggestions.add(station);
          _suggestionsSymbols += station.name.length;
        }
      });
    if (_suggestions.length > 1) {
      _suggestionsRows.add(1);
      _suggestionsSubjects.add(_suggestions);
    } else
      _useSuggestedOne(type);
  }

  void _useSuggestedOne(InputType type) {
    if (_suggestions.length == 1)
      switch (type) {
        case InputType.from:
          {
            setFromStation.add(_suggestions.first);
            break;
          }
        case InputType.to:
          {
            setToStation.add(_suggestions.first);
            break;
          }
      }
    _suggestionsRows.add(0);
  }

  void switchFromAndTo() {
    Station _temp = _fromStation;
    setFromStation.add(_toStation);
    setToStation.add(_temp);
    _fromStation = _toStation;
    _toStation = _temp;
    _fetchData();
  }

  void clearSuggestions() {
    _suggestions.clear();
    _suggestionsSubjects.add(_suggestions);
    _suggestionsRows.add(0);
  }

  List<Train> _allTrains = <Train>[];
  List<Train> _shownTrains = <Train>[];
  final _shownSubject = BehaviorSubject<List<Train>>();

//  Stream<List<Train>> get allTrains => _trainsSubject.stream;
  Stream<List<Train>> get shown => _shownSubject.stream;

//  Sink<List<Train>> get addAllTrains => _trainsSubject.sink;
  Sink<List<Train>> get addShown => _shownSubject.sink;

  Future<void> _loadStations() async {
    print("_loadStations");
    final _stationsRef = Firestore.instance
        .collection("stations")
        .orderBy("priority")
        .orderBy("order")
        .reference();
    final _query = await _stationsRef.getDocuments();
    _query.documents
        .forEach((doc) => _allStations.add(Station.fromDocumentSnapshot(doc)));
    print("Станций: ${_allStations.length}");
  }

  void close() {
    _shownSubject.close();
    _toStationController.close();
    _fromStationController.close();
    _toController.close();
    _fromController.close();
    _suggestionsRowsController.close();
    _isArrivalController.close();
    _selectedDateController.close();
  }

  String formatDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date.toLocal());

  String formatTime(DateTime time) =>
      DateFormat('HH:mm').format(time.toLocal());

//  final String _apiKey = "af9c8729-4e63-4689-8988-52703e1e3cd7";
  String _url;

  var isArr = false;
  var _selectedDate = DateTime.now();
  var limit = 10;
  var typeToShow;

  _fetchData() async {
    if (_toStation.name.isNotEmpty) {
      _shownTrains.clear();
      addShown.add(_shownTrains);
      _url =
          'https://us-central1-trains-3a75a.cloudfunctions.net/get_trains?to=${_toStation.code}';
      if (_fromStation != null && _fromStation.name.isNotEmpty)
        _url += "&from=${_fromStation.name}";
      else {
        var res = await _location();
        if (res != null) _url += res;
      }
      if (isArr) _url += "is_arrival=true";
      if (_selectedDate != null)
        _url +=
            "&date=${formatDate(_selectedDate)}&time=${formatTime(_selectedDate)}";
      if (typeToShow != null) _url += "&type=$typeToShow";
      if (limit != null) _url += "&limit=$limit";
      print(_url);
      final response = await http.get(_url);
      if (response.statusCode == 200) {
        (json.decode(response.body) as List<dynamic>).forEach((jsonTrain) {
          var _train = Train.fromDynamic(jsonTrain);
          _train.isGoingFromFirstStation = _train.from == _from;
          _train.isGoingToLastStation = _train.to == _to;
          _shownTrains.add(_train);
        });
        addShown.add(_shownTrains);
      }
    }
  }

  _location() async {
    var currentLocation;
    var location = new Location();
// Platform messages may fail, so we use a try/catch PlatformException.
    try {
      currentLocation = await location.getLocation();
      return "&lat=${currentLocation.latitude}&lng=${currentLocation.longitude}";
    } on PlatformException catch (e) {
      if (e.code == 'PERMISSION_DENIED') {
        print(e);
      }
      currentLocation = null;
    }
  }

//
//  _OLDfetchData() async {
//    if (_fromStation != null && _toStation != null) {
//      _url =
//          "https://api.rasp.yandex.net/v3.0/search/?apikey=$_apiKey&format=json&from=${_fromStation.code}&to=${_toStation.code}&lang=ru_RU&page=1&limit=150&transport_types=suburban&date=${formatDate(DateTime.now().toLocal())}";
//      _allTrains.clear();
//      _shownTrains.clear();
//      final response = await http.get(_url);
//      if (response.statusCode == 200) {
//        Map<String, dynamic> _map = json.decode(response.body) as Map;
//        List<dynamic> _list = _map['segments'];
//        _list.forEach((segment) {
//          var train = Train.fromDynamic(segment);
//          train.isGoingFromFirstStation = train.from == _from;
//          train.isGoingToLastStation = train.to == _to;
//          _allTrains.add(train);
//        });
//        int _soonest = _allTrains.indexOf(_allTrains
//            .firstWhere((train) => !_howSoon(train.departure).isNegative));
//        int _start = max(_soonest - 2, 0);
//        int _end = min(_soonest + 10, _allTrains.length);
//        _allTrains.sublist(_start, _end).forEach((train) {
//          _shownTrains.add(train);
//          addShown.add(_shownTrains);
//        });
//      } else {
//        _generate();
////        throw Exception(response.statusCode);
//      }
//    }
//  }

//  void _generate() {
//    var rnd = Random();
//    var now = DateTime.now().toLocal();
//    for (int i = -2; i <= 10; i++) {
//      var _type =
//          TrainType.values.elementAt(rnd.nextInt(TrainType.values.length));
//      var _dep = now.add(Duration(minutes: i * rnd.nextInt(60)));
//      var _arr = _dep.add(Duration(minutes: rnd.nextInt(15)));
//      var _pr = rnd.nextInt(190);
//      List<Stop> _stops = [];
//      var _stopDep = now.subtract(Duration(minutes: rnd.nextInt(200)));
//      var _stopArr;
//      for (int j = 0; j < _allStations.length; j++) {
//        _stops.add(Stop(_allStations.elementAt(j), j != 0 ? _stopArr : null,
//            j != _allStations.length ? _stopDep : null));
//        _stopArr = _stopDep.add(Duration(minutes: rnd.nextInt(10)));
//        _stopDep = _stopArr.add(Duration(minutes: rnd.nextInt(5)));
//      }
//      _stops.first.arrival = _stops.last.departure = null;
//      var _fromIndex = rnd.nextInt(_allStations.length);
//      var _toIndex = rnd.nextInt(_allStations.length);
//      if (_toIndex == _fromIndex)
//        _toIndex += rnd.nextInt(_allStations.length - _toIndex);
//      var _fromTitle = _allStations.elementAt(_fromIndex).name;
//      var _toTitle = _allStations.elementAt(_toIndex).name;
//      var _thread = Thread(_type, _stops);
//      var _uid = "${rnd.nextInt(1000000)}_${rnd.nextInt(100)}";
//      var _train =
//          Train(_type, _dep, _arr, _pr, _thread, _uid, _fromTitle, _toTitle);
//      _train.isGoingFromFirstStation = _train.from == _from;
//      _train.isGoingToLastStation = _train.to == _to;
//      _shownTrains.add(_train);
//    }
//    addShown.add(_shownTrains);
//  }

//  Future<void> fetchThread(String uid) async {
//    Train _train = _shownTrains.firstWhere((train) => train.uid == uid);
//    var index = _shownTrains.indexOf(_train);
//    String _url =
//        "https://api.rasp.yandex.net/v3.0/thread/?apikey=$_apiKey&format=json&uid=$uid&lang=ru_RU&show_systems=yandex";
//    print(_url);
//    final response = await http.get(_url);
//    if (response.statusCode == 200) {
//      Map<String, dynamic> _map = json.decode(response.body) as Map;
//      _train.thread = Thread.fromMap(_map);
//      _shownTrains.removeAt(index);
//      _shownTrains.insert(index, _train);
//      addShown.add(_shownTrains);
//    } else {
//      throw Exception(response.statusCode);
//    }
//  }

  Duration _howSoon(DateTime time) {
    return time.difference(DateTime.now());
  }
}
