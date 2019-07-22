import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trains/data/classes/stop.dart';
import 'package:trains/data/classes/train.dart';

class Thread {
  List<Stop> stops;
  String number;
  int stopsCount = 0;
  String title;
  String uid;
  TrainType type;
  DateTime startDateTime;
  DateTime endDateTime;

  Thread.fromDocumentSnapshot(DocumentSnapshot thread) {
    uid = thread.documentID;
    number = thread.data['number'];
    title = thread.data['title'];
    switch (thread.data['type']) {
      case "suburban":
        type = TrainType.suburban;
        break;
      case "last":
        type = TrainType.last;
        break;
      case "lastm":
        type = TrainType.lastm;
        break;
      default:
        type = TrainType.suburban;
        break;
    }
    List<dynamic> list = thread.data['stops'];
    stops = List();
    list.forEach((item) => stops.add(Stop.fromDynamic(item)));
    stopsCount = stops.length;
    startDateTime = stops.first.departure;
    endDateTime = stops.last.arrival;
  }
}
