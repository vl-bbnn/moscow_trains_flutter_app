import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/suggestion.dart';

class Stop {
  Station suggestion;
  DateTime arrival;
  DateTime departure;

  Duration stopTime;
  int index;

  void _getStopTime() {
    if (arrival != null && departure != null)
      stopTime = departure.difference(arrival).abs();
  }

  Stop(this.suggestion, this.arrival, this.departure) {
    _getStopTime();
  }

  Stop.fromDynamic(dynamic stop) {
    if (stop['stop_time'] != null)
      stopTime = Duration(seconds: stop['stop_time']);
    index = stop['index'];
    if (stop['departure'] != null) departure = stop['departure'].toDate();
    if (stop['arrival'] != null) arrival = stop['arrival'].toDate();
    suggestion = new Station(
        station: Station(name: stop['title'], code: stop['code']));
  }
}
