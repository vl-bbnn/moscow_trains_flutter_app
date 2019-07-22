import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  String code;
  String name;
  String direction;
  String city;
  String cityCode;
  GeoPoint location;

  Station.fromDocumentSnapshot(DocumentSnapshot doc) {
    code = doc.documentID;
    name = _shorterName(doc['name']);
    location = doc['coordinates'];
  }

  Station({String name, this.code}) {
    this.name = _shorterName(name);
  }

  String _shorterName(String name) {
    return name.replaceAll(' (Ленинградский вокзал)', '');
  }

  Station.fromDynamic(dynamic segmentChild) {
    code = segmentChild['code'];
    name = _shorterName(segmentChild['title']);
  }
}
