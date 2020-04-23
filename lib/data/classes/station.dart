import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  String code;
  String title;
  String subtitle;
  final keywords = List<String>();
  final transitList = List<Map<String, Object>>();
  GeoPoint location;
  GeoPoint mapCenter;
  double mapZoom;

  Station({this.title, this.subtitle});

  Station.fromDocumentSnapshot(DocumentSnapshot doc) {
    try {
      code = doc.documentID;
      title = doc['title'];
      if (doc['keywords'] != null) keywords.addAll(List.from(doc['keywords']));
      location = doc['coordinates'];
      final map = doc['map'];
      if (map != null) {
        mapCenter = map['center'] ?? GeoPoint(55.751538, 37.616039);
        mapZoom = map['zoom'].toDouble() ?? 17.0;
      } else {
        mapCenter = GeoPoint(55.751538, 37.616039);
        mapZoom = 17.0;
      }
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
