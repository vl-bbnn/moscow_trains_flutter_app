import 'package:rxdart/subjects.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';

class ScheduleBloc {
  final collapseToValue = 0.5;

  final scheduleDataInputStream = BehaviorSubject<ScheduleData>();

  final departureValue = BehaviorSubject<double>();
  final departureSelected = BehaviorSubject<bool>();
  final departureStation = BehaviorSubject<Station>();
  final departureIconValue = BehaviorSubject<double>();
  final departureTime = BehaviorSubject<DateTime>();

  final arrivalValue = BehaviorSubject<double>();
  final arrivalSelected = BehaviorSubject<bool>();
  final arrivalStation = BehaviorSubject<Station>();
  final arrivalIconValue = BehaviorSubject<double>();
  final arrivalTime = BehaviorSubject<DateTime>();

  final selectedValue = BehaviorSubject<double>();

  final trainClass = BehaviorSubject<TrainClass>();

  final inputSizes = BehaviorSubject<Sizes>();

  ScheduleBloc() {
    scheduleDataInputStream.listen((newData) {
      final sizes = inputSizes.value;
      final collapseValue = newData.collapseValue;
      final moveValue = newData.moveValue;
      final expandValue = newData.expandValue;
      final currentTrain = newData.currentTrain;
      final nextTrain = newData.nextTrain;

      if (sizes != null && nextTrain != null && expandValue > 0) {
        trainClass.add(nextTrain.trainClass);

        if (!nextTrain.departureSelected) {
          departureValue.add(
              expandValue.clamp(0.0, sizes.schemeDeparturePercent) /
                  sizes.schemeDeparturePercent);
          departureStation.add(nextTrain.from);
        }

        departureIconValue.add((expandValue -
                    sizes.schemeDeparturePercent +
                    sizes.schemeIconPercent / 2)
                .clamp(0.0, sizes.schemeIconPercent) /
            sizes.schemeIconPercent);
        departureSelected.add(nextTrain.departureSelected);

        selectedValue.add((expandValue - sizes.schemeDeparturePercent)
                .clamp(0.0, sizes.schemeSelectedPercent) /
            sizes.schemeSelectedPercent);

        arrivalIconValue.add((expandValue -
                    sizes.schemeDeparturePercent -
                    sizes.schemeSelectedPercent +
                    sizes.schemeIconPercent / 2)
                .clamp(0.0, sizes.schemeIconPercent) /
            sizes.schemeIconPercent);
        arrivalSelected.add(nextTrain.arrivalSelected);

        if (!nextTrain.arrivalSelected) {
          arrivalValue.add((expandValue -
                      sizes.schemeSelectedPercent -
                      sizes.schemeDeparturePercent)
                  .clamp(0.0, sizes.schemeArrivalPercent) /
              sizes.schemeArrivalPercent);
          arrivalStation.add(nextTrain.to);
        }
      } else if (sizes != null &&
          currentTrain != null &&
          collapseToValue >= 0) {
        trainClass.add(currentTrain.trainClass);

        if (!currentTrain.arrivalSelected) {
          arrivalValue.add(1 -
              (collapseValue.clamp(0.0, sizes.schemeArrivalPercent) /
                  sizes.schemeArrivalPercent));
          if (arrivalStation.value == null ||
              arrivalStation.value.code != currentTrain.to.code)
            arrivalStation.add(currentTrain.to);
        }

        arrivalIconValue.add(1 -
            ((collapseValue -
                        sizes.schemeArrivalPercent +
                        sizes.schemeIconPercent / 2)
                    .clamp(0.0, sizes.schemeIconPercent) /
                sizes.schemeIconPercent));
        if (arrivalSelected.value == null ||
            arrivalSelected.value != currentTrain.arrivalSelected)
          arrivalSelected.add(currentTrain.arrivalSelected);

        selectedValue.add(1 -
            ((collapseValue - sizes.schemeArrivalPercent)
                    .clamp(0.0, sizes.schemeSelectedPercent) /
                sizes.schemeSelectedPercent));

        departureIconValue.add(1 -
            ((collapseValue -
                        sizes.schemeArrivalPercent -
                        sizes.schemeSelectedPercent +
                        sizes.schemeIconPercent / 2)
                    .clamp(0.0, sizes.schemeIconPercent) /
                sizes.schemeIconPercent));
        if (departureSelected.value == null ||
            departureSelected.value != currentTrain.departureSelected)
          departureSelected.add(currentTrain.departureSelected);

        if (!currentTrain.departureSelected) {
          departureValue.add(1 -
              ((collapseValue -
                          sizes.schemeSelectedPercent -
                          sizes.schemeArrivalPercent)
                      .clamp(0.0, sizes.schemeDeparturePercent) /
                  sizes.schemeDeparturePercent));

          if (departureStation.value == null ||
              departureStation.value.code != currentTrain.from.code)
            departureStation.add(currentTrain.from);
        }
      }

      if (sizes != null && currentTrain != null && moveValue >= 0) {
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
          departureTime.add(newDeparture);

          final isArrivingLater =
              nextTrain.arrival.isAfter(currentTrain.arrival);
          final arrivalDiff =
              Helper.timeDiffInMins(currentTrain.arrival, nextTrain.arrival);
          final newArrival = isArrivingLater
              ? currentTrain.arrival
                  .add(Duration(minutes: (moveValue * arrivalDiff).round()))
              : currentTrain.arrival.subtract(
                  Duration(minutes: (moveValue * arrivalDiff).round()));
          arrivalTime.add(newArrival);
        } else {
          departureTime.add(currentTrain.departure);
          arrivalTime.add(currentTrain.arrival);
        }
      }
    });
  }

  close() {
    scheduleDataInputStream.close();

    departureValue.close();
    departureSelected.close();
    departureStation.close();
    departureIconValue.close();
    departureTime.close();

    arrivalValue.close();
    arrivalSelected.close();
    arrivalStation.close();
    arrivalIconValue.close();
    arrivalTime.close();

    selectedValue.close();

    inputSizes.close();

    trainClass.close();
  }
}
