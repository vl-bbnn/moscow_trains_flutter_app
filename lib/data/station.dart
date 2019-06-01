import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  String code;
  String name;
  String direction;
  String city;
  String cityCode;

  Station.fromDocumentSnapshot(DocumentSnapshot doc) {
    code = doc.documentID;
    name = _shorterName(doc['name']);
  }

  Station(this.name, this.code);

  String _shorterName(String name) {
    return name.replaceAll(' (Ленинградский вокзал)', '');
  }

  Station.fromDynamic(dynamic segmentChild) {
    code = segmentChild['code'];
    name = _shorterName(segmentChild['title']);
  }
}
