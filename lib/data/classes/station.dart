import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  String code;
  String name;
  String old;
  String subtitle;
  final keywords = List<String>();
  final transitList = List<Map<String, Object>>();
  GeoPoint location;

  Station.fromDocumentSnapshot(DocumentSnapshot doc) {
    code = doc.documentID;
    name = doc['name'];
    old = doc['old'] ?? " ";
    if (doc['keywords'] != null) keywords.addAll(List.from(doc['keywords']));
    location = doc['coordinates'];
    subtitle = doc['subtitle'] ?? " ";
    if (doc['transit'] != null) {
      transitList.addAll(List.from(doc['transit']
          .map((transit) => {'line': transit['line'], 'time': transit['time']})
          .toList()));
    }
  }
}
