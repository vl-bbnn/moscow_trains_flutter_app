import 'package:intl/intl.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';

class ScheduleData {
  DateTime time;
  DateTime targetTime;
  int minutesDiff;

  Station station;
  bool selected;

  ScheduleData({this.time, this.station, this.selected, this.targetTime}) {
    minutesDiff = Helper.timeDiffInMins(targetTime, time);
  }

  updateTargetTime(DateTime newTargetTime) {
    targetTime = newTargetTime;
    minutesDiff = Helper.timeDiffInMins(newTargetTime, time);
  }

  @override
  String toString() {
    return "\nTime: " +
        DateFormat("HH:mm").format(time) +
        "\nMinutes: " +
        minutesDiff.toString() +
        "\nStation: " +
        station.toString() +
        "\nSelected: " +
        selected.toString();
  }
}

class Schedule {
  TrainClass trainClass;
  double trainValue;
  double roadValue;
  double iconValue;

  ScheduleData departure;
  ScheduleData arrival;

  Station from;
  Station to;

  Schedule(
      {this.trainClass,
      this.departure,
      this.arrival,
      this.trainValue,
      this.roadValue,
      this.iconValue,
      this.from,
      this.to});

  @override
  String toString() {
    return ("Schedule: \nClass: " +
        trainClass.toString() +
        "\nTrain: " +
        trainValue.toString() +
        "\nRoad: " +
        roadValue.toString() +
        "\nIcon: " +
        iconValue.toString() +
        "\n\nFrom: " +
        from.toString() +
        "\n\nTo: " +
        to.toString() +
        "\n\nDeparture: " +
        departure.toString() +
        "\n\nArrival: " +
        arrival.toString());
  }
}

class ScheduleBloc {
  final sizesInput = BehaviorSubject<Sizes>();
  final searchParametersInput = BehaviorSubject<SearchParameters>();
  final trainsDataInput = BehaviorSubject<TrainsData>();

  final scheduleOutput = BehaviorSubject<Schedule>();

  ScheduleBloc() {
    searchParametersInput.listen((parameters) {
      if (scheduleOutput.value != null) {
        final schedule = scheduleOutput.value;
        schedule.departure.updateTargetTime(parameters.time);
        schedule.arrival.updateTargetTime(parameters.time);
        schedule.from = parameters.from;
        schedule.to = parameters.to;
        scheduleOutput.add(schedule);
      }
    });
    trainsDataInput.listen((newData) {
      final scheme = sizesInput.value?.scheme;
      final collapseValue = newData.collapseValue;
      final moveValue = newData.moveValue;
      final expandValue = newData.expandValue;
      final currentTrain = newData.currentTrain;
      final nextTrain = newData.nextTrain;
      final targetTime = searchParametersInput.value.time;
      final fromStation = searchParametersInput.value.from;
      final toStation = searchParametersInput.value.to;

      TrainClass trainClass;
      double trainValue;
      double iconValue;
      double roadValue;

      DateTime departureTime;
      Station departureStation;
      bool fromStart;

      DateTime arrivalTime;
      Station arrivalStation;
      bool toEnd;

      if (scheme != null && nextTrain != null && expandValue > 0) {
        trainValue =
            expandValue.clamp(0.0, scheme.trainPercent) / scheme.trainPercent;

        iconValue = (expandValue - scheme.trainPercent + scheme.iconPercent / 2)
                .clamp(0.0, scheme.iconPercent) /
            scheme.iconPercent;

        roadValue =
            (expandValue - scheme.trainPercent).clamp(0.0, scheme.roadPercent) /
                scheme.roadPercent;

        trainClass = nextTrain.trainClass;

        fromStart = nextTrain.fromStart;
        toEnd = nextTrain.toEnd;

        departureStation = nextTrain.from.station;
        arrivalStation = nextTrain.to.station;
      } else if (scheme != null && currentTrain != null && collapseValue >= 0) {
        roadValue = 1 -
            collapseValue.clamp(0.0, scheme.roadPercent) / scheme.roadPercent;

        iconValue = 1 -
            (collapseValue - scheme.roadPercent + scheme.iconPercent / 2)
                    .clamp(0.0, scheme.iconPercent) /
                scheme.iconPercent;

        trainValue = 1 -
            (collapseValue - scheme.roadPercent)
                    .clamp(0.0, scheme.trainPercent) /
                scheme.trainPercent;

        trainClass = currentTrain.trainClass;

        fromStart = currentTrain.fromStart;
        toEnd = currentTrain.toEnd;

        departureStation = currentTrain.from.station;
        arrivalStation = currentTrain.to.station;
      }

      if (scheme != null && currentTrain != null && moveValue >= 0) {
        if (nextTrain != null) {
          final isDeparturingLater =
              nextTrain.departure.isAfter(currentTrain.departure);
          final departureDiff = Helper.timeDiffInMins(
              currentTrain.departure, nextTrain.departure);
          final newDeparture = isDeparturingLater
              ? currentTrain.departure
                  .add(Duration(minutes: (moveValue * departureDiff).round()))
              : currentTrain.departure.subtract(
                  Duration(minutes: (moveValue * departureDiff).round()));

          departureTime = newDeparture;

          final isArrivingLater =
              nextTrain.arrival.isAfter(currentTrain.arrival);
          final arrivalDiff =
              Helper.timeDiffInMins(currentTrain.arrival, nextTrain.arrival);
          final newArrival = isArrivingLater
              ? currentTrain.arrival
                  .add(Duration(minutes: (moveValue * arrivalDiff).round()))
              : currentTrain.arrival.subtract(
                  Duration(minutes: (moveValue * arrivalDiff).round()));

          arrivalTime = newArrival;
        } else {
          departureTime = currentTrain.departure;

          arrivalTime = currentTrain.arrival;
        }
      }

      final departure = ScheduleData(
          selected: fromStart,
          station: departureStation,
          time: departureTime,
          targetTime: targetTime);

      final arrival = ScheduleData(
          station: arrivalStation,
          selected: toEnd,
          time: arrivalTime,
          targetTime: targetTime);

      final schedule = Schedule(
        trainClass: trainClass,
        trainValue: trainValue,
        from: fromStation,
        to: toStation,
        roadValue: roadValue,
        iconValue: iconValue,
        departure: departure,
        arrival: arrival,
      );

      scheduleOutput.add(schedule);
    });
  }

  close() {
    trainsDataInput.close();
    scheduleOutput.close();

    trainsDataInput.close();

    sizesInput.close();
  }
}
