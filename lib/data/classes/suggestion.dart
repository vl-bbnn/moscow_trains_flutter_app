import 'package:trains/data/classes/station.dart';

enum Label { closest, home, work, custom, other }

class Station {
  Station station;
  Label label;
  String text;

  Station({this.station, Label label, this.text}) {
    this.label = label != null ? label : Label.other;
  }
}
