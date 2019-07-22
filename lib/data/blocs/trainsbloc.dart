import 'dart:async';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/classes/listitem.dart';
import 'package:trains/data/classes/pause.dart';
import 'package:trains/data/classes/suggestion.dart';
import 'package:trains/data/classes/thread.dart';
import 'package:trains/data/classes/train.dart';

enum Results { searching, found, notFound }
enum SearchParameter { from, to, dateTime, arrival, thread }

class TrainsBloc {
  TrainsBloc() {
    updateSelectedDate(DateTime.now());
    updateArrival(false);
    _timer();
  }

  switchInputs() {
    var from = _searchParameters[SearchParameter.from];
    _searchParameters[SearchParameter.from] =
        _searchParameters[SearchParameter.to];
    _searchParameters[SearchParameter.to] = from;
    searchParametersSink.add(_searchParameters);
    _isReadyToSearch();
  }

  _isReadyToSearch() {
    var isReady = _searchParameters[SearchParameter.from] != null &&
        _searchParameters[SearchParameter.to] != null;
    readyToSearchSink.add(isReady);
  }

  updateThread(String uid) async {
    _searchParameters[SearchParameter.thread] = uid;
    searchParametersSink.add(_searchParameters);
    await _fetchThread();
  }

  updateFrom(Suggestion suggestion) {
    _searchParameters[SearchParameter.from] = suggestion;
    searchParametersSink.add(_searchParameters);
    _isReadyToSearch();
  }

  updateTo(Suggestion suggestion) {
    _searchParameters[SearchParameter.to] = suggestion;
    searchParametersSink.add(_searchParameters);
    _isReadyToSearch();
  }

  updateSelectedDate(DateTime dateTime) {
    var now = DateTime.now();
    if (dateTime != null && dateTime.difference(now).inMinutes.abs() > 10) {
      _searchParameters[SearchParameter.dateTime] = dateTime;
      _timerUpdatesTimes = false;
    } else {
      _searchParameters[SearchParameter.dateTime] = now;
      _timerUpdatesTimes = true;
    }
    searchParametersSink.add(_searchParameters);
    _isReadyToSearch();
  }

  updateArrival(arrival) {
    _searchParameters[SearchParameter.arrival] = arrival;
    searchParametersSink.add(_searchParameters);
    _isReadyToSearch();
  }

  Map<SearchParameter, Object> _searchParameters =
      new Map<SearchParameter, Object>();

  Sink<Map<SearchParameter, Object>> get searchParametersSink =>
      _searchParametersController.sink;

  Stream<Map<SearchParameter, Object>> get searchParametersStream =>
      _searchParametersController.stream;
  final _searchParametersController =
      BehaviorSubject<Map<SearchParameter, Object>>();

  String formatDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date.toLocal());

  String folderNameFromDate(DateTime date) =>
      DateFormat('dd-MM').format(date.toLocal());

  String formatTime(DateTime time) =>
      DateFormat('HH:mm').format(time.toLocal());

  var _timerUpdatesTrains = false;
  var _timerUpdatesTimes = true;
  var _limit = 100;
  var _allListItemsList = new List<ListItem>();
  var _regularListItemsList = new List<ListItem>();
  var _comfortListItemsList = new List<ListItem>();
  var _expressListItemsList = new List<ListItem>();

  Sink<bool> get readyToSearchSink => _readyToSearchController.sink;

  Stream<bool> get readyToSearchStream => _readyToSearchController.stream;
  final _readyToSearchController = BehaviorSubject<bool>();

  Sink<Results> get searchingSink => _searchingController.sink;

  Stream<Results> get searchingStream => _searchingController.stream;
  final _searchingController = BehaviorSubject<Results>();

  Sink<List<ListItem>> get allListItemsSink => _allListItemsController.sink;

  Stream<List<ListItem>> get allListItemsStream =>
      _allListItemsController.stream;
  final _allListItemsController = BehaviorSubject<List<ListItem>>();

  Sink<List<ListItem>> get regularListItemsSink =>
      _regularListItemsController.sink;

  Stream<List<ListItem>> get regularListItemsStream =>
      _regularListItemsController.stream;
  final _regularListItemsController = BehaviorSubject<List<ListItem>>();

//  Sink<String> get selectedTrainSink => _selectedTrainController.sink;
//
//  Stream<String> get selectedTrainStream => _selectedTrainController.stream;
//  final _selectedTrainController = BehaviorSubject<String>();

  Sink<List<ListItem>> get comfortListItemsSink =>
      _comfortListItemsController.sink;

  Stream<List<ListItem>> get comfortListItemsStream =>
      _comfortListItemsController.stream;
  final _comfortListItemsController = BehaviorSubject<List<ListItem>>();

  Sink<List<ListItem>> get expressListItemsSink =>
      _expressListItemsController.sink;

  Stream<List<ListItem>> get expressListItemsStream =>
      _expressListItemsController.stream;
  final _expressListItemsController = BehaviorSubject<List<ListItem>>();

  Sink<Thread> get threadSink => _threadController.sink;

  Stream<Thread> get threadStream => _threadController.stream;
  final _threadController = BehaviorSubject<Thread>();

  _fetchThread() async {
    threadSink.add(null);
    final uid = _searchParameters[SearchParameter.thread] as String;
    final dateTime = _searchParameters[SearchParameter.dateTime] as DateTime;
    var _url =
        'https://us-central1-trains-3a75a.cloudfunctions.net/get_thread?uid=$uid';
    if (dateTime != null) _url += "&date=${formatDate(dateTime)}";
    final response = await http.get(_url);
    if (response.statusCode == 200 && response.body == "true") {
      final threadRef = Firestore.instance
          .collection("threads")
          .document(folderNameFromDate(dateTime))
          .collection("threadsOfTheDate")
          .document(uid);
      final doc = await threadRef.get();
      if (doc.exists) {
        final thread = Thread.fromDocumentSnapshot(doc);
        if (thread.uid != null) threadSink.add(thread);
      } else
        print("Document not found");
    }
  }

  fetch() async {
    if (_searchParameters[SearchParameter.from] != null &&
        _searchParameters[SearchParameter.to] != null) await _fetchData();
  }

  _fetchData() async {
    searchingSink.add(Results.searching);
    _allListItemsList.clear();
    _regularListItemsList.clear();
    _comfortListItemsList.clear();
    _expressListItemsList.clear();
    var from = (_searchParameters[SearchParameter.from] as Suggestion).station;
    var to = (_searchParameters[SearchParameter.to] as Suggestion).station;
    var dateTime = _searchParameters[SearchParameter.dateTime] as DateTime;
    var arrival = _searchParameters[SearchParameter.arrival] as bool;
    var _url =
        'https://us-central1-trains-3a75a.cloudfunctions.net/get_trains?to=${to.code}&from=${from.code}';
    if (arrival != null && arrival) _url += "&is_arrival=true";
    if (dateTime != null)
      _url += "&date=${formatDate(dateTime)}&time=${formatTime(dateTime)}";
    if (_limit != null) _url += "&limit=$_limit";
    print(_url);
    final response = await http.get(_url);
    if (response.statusCode == 200) {
//      Train oldTrain;
      Train oldRegular;
      Train oldComfort;
      Train oldExpress;
      (json.decode(response.body) as List<dynamic>).forEach((jsonListItem) {
        var train = Train.fromDynamic(jsonListItem);
        train.isGoingFromFirstStation =
            train.from.toLowerCase() == from.name.toLowerCase();
        train.isGoingToLastStation =
            train.to.toLowerCase() == to.name.toLowerCase();
        var item = new ListItem(type: ListItemType.train, train: train);
//        if (pause != null) _allListItemsList.add(pause);
//        _allListItemsList.add(item);
        if (train.type == TrainType.suburban) {
          ListItem pause;
          if (oldRegular != null) {
            var pauseTime = oldRegular.departure
                .difference(train.departure)
                .inMinutes
                .abs();
            if (pauseTime > 60)
              pause = new ListItem(
                  type: ListItemType.pause, pause: new Pause(pauseTime));
          }
          if (pause != null) _regularListItemsList.add(pause);
          oldRegular = train;
          _regularListItemsList.add(item);
        } else if (train.type == TrainType.lastm) {
          ListItem pause;
          if (oldComfort != null) {
            var pauseTime = oldComfort.departure
                .difference(train.departure)
                .inMinutes
                .abs();
            if (pauseTime > 60)
              pause = new ListItem(
                  type: ListItemType.pause, pause: new Pause(pauseTime));
          }
          if (pause != null) _comfortListItemsList.add(pause);
          oldComfort = train;
          _comfortListItemsList.add(item);
        } else if (train.type == TrainType.last) {
          ListItem pause;
          if (oldExpress != null) {
            var pauseTime = oldExpress.departure
                .difference(train.departure)
                .inMinutes
                .abs();
            if (pauseTime >= 60)
              pause = new ListItem(
                  type: ListItemType.pause, pause: new Pause(pauseTime));
          }
          if (pause != null) _expressListItemsList.add(pause);
          oldExpress = train;
          _expressListItemsList.add(item);
        }
      });
    }
    var foundAnything = _regularListItemsList.length +
            _comfortListItemsList.length +
            _expressListItemsList.length >
        0;
    if (foundAnything) {
//        allListItemsSink.add(_allListItemsList);
      regularListItemsSink.add(_regularListItemsList);
      comfortListItemsSink.add(_comfortListItemsList);
      expressListItemsSink.add(_expressListItemsList);
      searchingSink.add(Results.found);
      _timerUpdatesTrains = true;
    } else {
      searchingSink.add(Results.notFound);
      _timerUpdatesTrains = false;
    }
  }

  void _timer() {
    var seconds = 60 - DateTime.now().second;
    Future.delayed(Duration(seconds: seconds), () {
      _timerUpdate();
      Timer.periodic(Duration(minutes: 1), (Timer t) {
        _timerUpdate();
      });
    });
  }

  _timerUpdate() {
    if (_timerUpdatesTimes) updateSelectedDate(DateTime.now());
    if (_timerUpdatesTrains) _updateListItems();
  }

  void _updateListItems() {
    if (_updateList(_allListItemsList)) allListItemsSink.add(_allListItemsList);
    if (_updateList(_regularListItemsList))
      regularListItemsSink.add(_regularListItemsList);
    if (_updateList(_comfortListItemsList))
      comfortListItemsSink.add(_comfortListItemsList);
    if (_updateList(_expressListItemsList))
      expressListItemsSink.add(_expressListItemsList);
  }

  bool _updateList(List<ListItem> list) {
    var length = list.length;
    if (length == 0) return false;
    var firstItem = list.elementAt(0);
    var secondItem;
    if (length > 1) secondItem = list.elementAt(1);
    if (firstItem.type == ListItemType.train) {
      bool result =
          (firstItem.train.departure.difference(DateTime.now()).inMinutes <=
              -1);
      if (result) {
        if (secondItem != null && secondItem.type == ListItemType.pause)
          list.removeAt(1);
        list.removeAt(0);
        return result;
      }
    } else if (firstItem.type == ListItemType.pause) list.removeAt(0);
    return list.length != length;
  }

  close() {
    _allListItemsController.close();
    _regularListItemsController.close();
    _comfortListItemsController.close();
    _expressListItemsController.close();
    _readyToSearchController.close();
    _searchingController.close();
    _searchParametersController.close();
    _threadController.close();
  }
}
