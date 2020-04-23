import 'package:rxdart/subjects.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';

class MainScreenBloc {
  final map = BehaviorSubject.seeded(Map<String, dynamic>());
  final timeMap = BehaviorSubject.seeded(Map<String, dynamic>());

  // final departureTime = BehaviorSubject<DateTime>();
  // final arrivalTime = BehaviorSubject<DateTime>();
  Train _currentTrain;
  Train _nextTrain;

  updateCurrentTrain(Train newTrain) {
    if (newTrain != null) {
      _currentTrain = newTrain;
      final oldMap = map.value;
      oldMap['currentDeparture'] = newTrain.from.title;
      oldMap['currentArrival'] = newTrain.to.title;
      oldMap['currentDepartureSelected'] = newTrain.departureSelected;
      oldMap['currentArrivalSelected'] = newTrain.arrivalSelected;
      oldMap['currentTrainClass'] = newTrain.trainClass;
      map.add(oldMap);

      final oldTimeMap = timeMap.value;
      if (oldTimeMap['departureTime'] == null ||
          oldTimeMap['arrivalTime'] == null) updateCurvedValue();
    }
  }

  updateNextTrain(Train newTrain) {
    if (newTrain != null) {
      _nextTrain = newTrain;
      final oldMap = map.value;
      oldMap['nextDeparture'] = newTrain.from.title;
      oldMap['nextArrival'] = newTrain.to.title;
      oldMap['nextDepartureSelected'] = newTrain.departureSelected;
      oldMap['nextArrivalSelected'] = newTrain.arrivalSelected;
      oldMap['nextTrainClass'] = newTrain.trainClass;
      map.add(oldMap);
    }
  }

  updateCurrentTime(DateTime newDateTime) {
    final oldTimeMap = timeMap.value;
    oldTimeMap['currentTime'] = newDateTime;
    timeMap.add(oldTimeMap);
  }

  updateFrom(Station fromStation) {
    final oldMap = map.value;
    oldMap['fromStation'] = fromStation;
    map.add(oldMap);
  }

  updateTo(Station toStation) {
    final oldMap = map.value;
    oldMap['toStation'] = toStation;
    map.add(oldMap);
  }

  close() {
    map.close();
    timeMap.close();
  }

  updateCurvedValue({double newCurvedValue}) {
    final oldMap = map.value;
    final oldTimeMap = timeMap.value;
    final curvedValue = newCurvedValue ?? oldMap['curvedValue'] ?? 0.0;
    if (_currentTrain != null) {
      if (_nextTrain != null) {
        final isDeparturingLater =
            _nextTrain.departure.isAfter(_currentTrain.departure);
        final departureDiff = Helper.timeDiffInMins(
            _currentTrain.departure, _nextTrain.departure);
        final newDeparture = isDeparturingLater
            ? _currentTrain.departure
                .add(Duration(minutes: (curvedValue * departureDiff).round()))
            : _currentTrain.departure.subtract(
                Duration(minutes: (curvedValue * departureDiff).round()));
        oldTimeMap['departureTime'] = newDeparture;

        final isArrivingLater =
            _nextTrain.arrival.isAfter(_currentTrain.arrival);
        final arrivalDiff =
            Helper.timeDiffInMins(_currentTrain.arrival, _nextTrain.arrival);
        final newArrival = isArrivingLater
            ? _currentTrain.arrival
                .add(Duration(minutes: (curvedValue * arrivalDiff).round()))
            : _currentTrain.arrival.subtract(
                Duration(minutes: (curvedValue * arrivalDiff).round()));
        oldTimeMap['arrivalTime'] = newArrival;
      } else {
        oldTimeMap['departureTime'] = _currentTrain.departure;
        oldTimeMap['arrivalTime'] = _currentTrain.arrival;
      }
    }
    oldMap['curvedValue'] = curvedValue;
    map.add(oldMap);
    timeMap.add(oldTimeMap);
  }
}
