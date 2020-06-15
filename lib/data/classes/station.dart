import 'package:cloud_firestore/cloud_firestore.dart';

class Station {
  String code;
  String title;
  String subtitle;

  bool terminal;
  GeoPoint location;
  double angle;
  List<Map<String, Object>> transitList;

  List<String> lines;
  List<String> keywords;

  Station.fromDocument(dynamic doc) {
    code = doc['code'] ?? doc.documentID;
    title = doc['title'] ?? '';
    subtitle = doc['subtitle'] ?? '';

    terminal = doc['terminal'] ?? false;
    location = doc['corrected_coordinates'] ?? doc['coordinates'];
    angle = doc['angle'] ?? 0.0;
    transitList = doc['transit'] != null
        ? List.from(doc['transit']
            .map((transit) =>
                {'lines': transit['lines'], 'time': transit['time']})
            .toList())
        : List();

    lines = doc['lines'] != null ? List.from(doc['lines']) : List();
    keywords = doc['keywords'] != null ? List.from(doc['keywords']) : List();
  }

  @override
  String toString() {
    return "\n" +
        code +
        ". " +
        title +
        "\n" +
        subtitle +
        "\nTerminal: " +
        terminal.toString() +
        "\nTransits: " +
        transitList.length.toString();
  }
}
