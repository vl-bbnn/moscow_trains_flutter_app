import 'package:trains/data/classes/station.dart';

enum Label { closest, home, work, custom, other }

class Suggestion {
  Station station;
  Label label;
  String text;

  Suggestion({this.station, Label label, this.text}) {
    this.label = label != null ? label : Label.other;
  }
}
