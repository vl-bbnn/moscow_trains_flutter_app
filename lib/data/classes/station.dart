import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  String code;
  String title;
  String subtitle;
  bool terminal;
  final keywords = List<String>();
  final transitList = List<Map<String, Object>>();
  GeoPoint location;

  Station({this.title, this.subtitle});

  Station.fromDocumentSnapshot(DocumentSnapshot doc) {
    try {
      code = doc.documentID;
      terminal = doc['terminal'] ?? false;
      title = doc['title'];
      if (doc['keywords'] != null) keywords.addAll(List.from(doc['keywords']));
      location = doc['coordinates'];
      subtitle = doc['subtitle'] ?? "";
      if (doc['transit'] != null) {
        transitList.addAll(List.from(doc['transit']
            .map((transit) =>
                {'lines': transit['lines'], 'time': transit['time']})
            .toList()));
      }
    } catch (err) {
      print("Station parse error: " + err);
    }
  }
}
