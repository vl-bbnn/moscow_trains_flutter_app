import 'package:trains/data/station.dart';

class Stop {
  Station station;
  DateTime arrival;
  DateTime departure;
  Duration stopTime;

  void _getStopTime() {
    if (arrival != null && departure != null)
      stopTime = departure.difference(arrival).abs();
  }

  Stop(this.station, this.arrival, this.departure) {
    _getStopTime();
  }

  Stop.fromDynamic(dynamic stop) {
    if (stop['stop_time'] != null)
      stopTime = Duration(seconds: stop['stop_time']);
    if (stop['departure'] != null)
      departure = DateTime.parse(stop['departure']);
    if (stop['arrival'] != null) arrival = DateTime.parse(stop['arrival']);
    station = Station.fromDynamic(stop['station']);
  }
}
