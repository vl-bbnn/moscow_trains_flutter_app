import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trains/data/classes/station.dart';

enum TrainClass { standart, comfort, express }

class TrainStop {
  Station station;
  DateTime departure;
  DateTime arrival;
  int stopTime;

  TrainStop.fromDocument(dynamic doc) {
    station = Station.fromDocument(doc['station']);

    departure = (doc['departure'] as Timestamp).toDate().toLocal();
    if (departure?.year == 1970) departure = null;

    arrival = (doc['arrival'] as Timestamp).toDate().toLocal();
    if (arrival?.year == 1970) arrival = null;

    stopTime = doc['stop_time'];
  }
}

class Train {
  DateTime departure;
  DateTime arrival;
  TrainClass trainClass;
  int price;
  String uid;

  TrainStop from;
  int fromIndex;

  TrainStop to;
  int toIndex;

  TrainStop start;
  bool fromStart;

  TrainStop end;
  bool toEnd;

  List<TrainStop> stopsBeforeDeparture;
  List<TrainStop> stopsAfterArrival;
  List<TrainStop> stopsOnTheWay;

  Train.fromDynamic(dynamic doc) {
    from = TrainStop.fromDocument(doc['from']['stop']);
    fromIndex = doc['from']['index'];

    to = TrainStop.fromDocument(doc['to']['stop']);
    toIndex = doc['to']['index'];

    start = TrainStop.fromDocument(doc['start']);
    fromStart = doc['from_start']?? false;

    end = TrainStop.fromDocument(doc['end']);
    toEnd = doc['to_end'] ?? false;

    price = doc['price'] ?? 0;

    uid = doc['uid'];

    departure = (doc['departure'] as Timestamp).toDate().toLocal();

    arrival = (doc['arrival'] as Timestamp).toDate().toLocal();

    stopsBeforeDeparture = (doc['before_departure']['stops'] as List<dynamic>)
        .map((stopData) => TrainStop.fromDocument(stopData))
        .toList();

    stopsOnTheWay = (doc['on_the_way']['stops'] as List<dynamic>)
        .map((stopData) => TrainStop.fromDocument(stopData))
        .toList();

    stopsAfterArrival = (doc['after_arrival']['stops'] as List<dynamic>)
        .map((stopData) => TrainStop.fromDocument(stopData))
        .toList();

    switch (doc['type']) {
      case 'last':
        {
          trainClass = TrainClass.express;
          break;
        }
      case 'lastm':
        {
          trainClass = TrainClass.comfort;
          break;
        }
      default:
        {
          trainClass = TrainClass.standart;
          break;
        }
    }
  }
}
