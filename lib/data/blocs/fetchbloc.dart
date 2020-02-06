import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';

class FetchBloc {
  FetchBloc() {
    trains.add(List<Train>());
  }

  String formatDate(DateTime date) =>
      DateFormat("yyyy-MM-ddTHH:mm").format(date.toLocal());

  String folderNameFromDate(DateTime date) =>
      DateFormat('DD-MM').format(date.toLocal());

  final trains = BehaviorSubject<List<Train>>();

  search(
      Station reqFrom, Station reqTo, DateTime reqDate, Input reqType) async {
    final date = reqDate ?? DateTime.now(), list = List<Train>();
    trains.add(list);
    final scheduleRef = Firestore.instance
            .collection("schedule")
            .document(folderNameFromDate(date))
            .collection("queriesOfTheDate")
            .document(reqFrom.code + '-' + reqTo.code),
        doc = await scheduleRef.get();
    if (doc.exists) {
      doc.data['trains'].forEach((train) => list.add(Train.fromDynamic(train)));
      trains.add(list);
    } else {
      print("Document not found in Firestore path: " +
          scheduleRef.path +
          ".\nMaking a request with URL:");
      var _url =
          'https://us-central1-trains-3a75a.cloudfunctions.net/get_trains?to=${reqTo.code}' +
              '&from=${reqFrom.code}&date=${formatDate(date)}';
      print(_url);
      final response = await http.get(_url);
      if (response.statusCode == 200 && response.body == "true") {
        final doc = await scheduleRef.get();
        if (doc.exists) {
          doc.data['trains']
              .forEach((train) => list.add(Train.fromDynamic(train)));
        } else {
          print("Document not found again. Error");
        }
        trains.add(list);
      }
    }
  }

  close() {
    trains.close();
  }
}
