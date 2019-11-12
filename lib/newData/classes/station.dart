import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trains/newData/classes/transit.dart';

class Station {
  String code;
  String name;
  String subtitle;
  String direction;
  String city;
  String cityCode;
  List<Transit> transitList = new List();
  GeoPoint location;

  Station.fromDocumentSnapshot(DocumentSnapshot doc) {
    code = doc.documentID;
    name = _shorterName(doc['name']);
    location = doc['coordinates'];
    subtitle = doc['subtitle'] ?? " ";
    if (doc['transit'] != null) {
      final list = List.from(doc['transit']);
      if (list.isNotEmpty)
        transitList.addAll(list
            .map((object) => new Transit(map: object as Map<dynamic, dynamic>))
            .toList());
    }
  }

  Station({String name, this.subtitle, this.code}) {
    this.name = _shorterName(name);
  }

  String _shorterName(String name) {
    return name.replaceAll(' (Ленинградский вокзал)', '');
  }
}
