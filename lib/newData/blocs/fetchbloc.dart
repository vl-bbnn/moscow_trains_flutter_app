import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/newData/blocs/inputtypebloc.dart';
import 'package:trains/newData/classes/station.dart';
import 'package:trains/newData/classes/train.dart';

class FetchBloc {
  FetchBloc() {
    trains.add(List<Train>());
  }

  String formatDateTime(DateTime date) =>
      DateFormat('yyyy-MM-ddTHH:mm').format(date.toLocal());

  String folderNameFromDate(DateTime date) =>
      DateFormat('dd-MM').format(date.toLocal());

  // String formatTime(DateTime time) =>
  //     DateFormat('HH:mm').format(time.toLocal());


  final trains = BehaviorSubject<List<Train>>();

  // Sink<Thread> get threadSink => _threadController.sink;

  // Stream<Thread> get threadStream => _threadController.stream;
  // final _threadController = BehaviorSubject<Thread>();

  // _fetchThread() async {
  //   threadSink.add(null);
  //   final uid = _searchParameters[SearchParameter.thread] as String;
  //   final dateTime = _searchParameters[SearchParameter.dateTime] as DateTime;
  //   var _url =
  //       'https://us-central1-trains-3a75a.cloudfunctions.net/get_thread?uid=$uid';
  //   if (dateTime != null) _url += "&date=${formatDate(dateTime)}";
  //   final response = await http.get(_url);
  //   if (response.statusCode == 200 && response.body == "true") {
  //     final threadRef = Firestore.instance
  //         .collection("threads")
  //         .document(folderNameFromDate(dateTime))
  //         .collection("threadsOfTheDate")
  //         .document(uid);
  //     final doc = await threadRef.get();
  //     if (doc.exists) {
  //       final thread = Thread.fromDocumentSnapshot(doc);
  //       if (thread.uid != null) threadSink.add(thread);
  //     } else
  //       print("Document not found");
  //   }
  // }

  search(Station fromStation, Station toStation, DateTime dateTime,
      Input dateTimeType) async {
    var _url =
        'https://us-central1-trains-3a75a.cloudfunctions.net/get_trains?to=${toStation.code}&from=${fromStation.code}';
    if (dateTime != null) _url += "&dateTime=${formatDateTime(dateTime)}";
    if (dateTimeType != null) {
      final type = dateTimeType.toString().replaceAll("Input.", "");
      _url += "&type=$type";
    }
    print(_url);
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      final list = List<Train>();
      (json.decode(response.body) as List<dynamic>).forEach((jsonListItem) {
        final train = Train.fromDynamic(jsonListItem);
        train.isGoingFromFirstStation =
            train.from.toLowerCase() == fromStation.name.toLowerCase();
        train.isGoingToLastStation =
            train.to.toLowerCase() == toStation.name.toLowerCase();
        train.targetIsArrival = dateTimeType == Input.arrival;
        list.add(train);
      });
      trains.add(list);
    }
  }

  close() {
    trains.close();
  }
}
