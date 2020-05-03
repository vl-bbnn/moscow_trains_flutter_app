import 'package:rxdart/subjects.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';

class ScheduleBloc {
  final collapseToValue = 0.5;
  final schemeHeight = 812.0;

  final valueInputStream = BehaviorSubject<double>();
  final selectedTrainInputStream = BehaviorSubject<Train>();
  final currentTrainInputStream = BehaviorSubject<Train>();

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
    valueInputStream.listen((newValue) {
      if (inputSizes.value != null) {
        final sizes = inputSizes.value;
        final currentTrain = currentTrainInputStream.value;
        if (currentTrain != null) {
          final selectedTrain = selectedTrainInputStream.value;
          if (selectedTrain != null) {
            //Updating departure & arrival time between current and selected trains
            final isDeparturingLater = selectedTrainInputStream.value.departure
                .isAfter(currentTrainInputStream.value.departure);
            final departureDiff = Helper.timeDiffInMins(
                currentTrainInputStream.value.departure,
                selectedTrainInputStream.value.departure);
            final newDeparture = isDeparturingLater
                ? currentTrainInputStream.value.departure.add(Duration(
                    minutes: (valueInputStream.value * departureDiff).round()))
                : currentTrainInputStream.value.departure.subtract(Duration(
                    minutes: (valueInputStream.value * departureDiff).round()));
            departureTime.add(newDeparture);

            final isArrivingLater = selectedTrainInputStream.value.arrival
                .isAfter(currentTrainInputStream.value.arrival);
            final arrivalDiff = Helper.timeDiffInMins(
                currentTrainInputStream.value.arrival,
                selectedTrainInputStream.value.arrival);
            final newArrival = isArrivingLater
                ? currentTrainInputStream.value.arrival.add(Duration(
                    minutes: (valueInputStream.value * arrivalDiff).round()))
                : currentTrainInputStream.value.arrival.subtract(Duration(
                    minutes: (valueInputStream.value * arrivalDiff).round()));
            arrivalTime.add(newArrival);
          } else {
            departureTime.add(currentTrain.departure);
            arrivalTime.add(currentTrain.arrival);
          }

          final collapsingValue =
              newValue.clamp(0.0, collapseToValue) / collapseToValue;
          final expandValue = 1 - collapseToValue;
          final expandingValue =
              (newValue - collapseToValue).clamp(0.0, expandValue) /
                  expandValue;

          if (expandingValue > 0) //Expanding from none to selected train
          {
            trainClass.add(selectedTrain.trainClass);

            if (!selectedTrain.departureSelected) {
              departureValue.add(
                  expandingValue.clamp(0.0, sizes.schemeDeparturePercent) /
                      sizes.schemeDeparturePercent);
              departureStation.add(selectedTrain.from);
            }

            departureIconValue.add((expandingValue -
                        sizes.schemeDeparturePercent +
                        sizes.schemeIconPercent / 2)
                    .clamp(0.0, sizes.schemeIconPercent) /
                sizes.schemeIconPercent);
            departureSelected.add(selectedTrain.departureSelected);

            selectedValue.add((expandingValue - sizes.schemeDeparturePercent)
                    .clamp(0.0, sizes.schemeSelectedPercent) /
                sizes.schemeSelectedPercent);

            arrivalIconValue.add((expandingValue -
                        sizes.schemeDeparturePercent -
                        sizes.schemeSelectedPercent +
                        sizes.schemeIconPercent / 2)
                    .clamp(0.0, sizes.schemeIconPercent) /
                sizes.schemeIconPercent);
            arrivalSelected.add(selectedTrain.arrivalSelected);

            if (!selectedTrain.arrivalSelected) {
              arrivalValue.add((expandingValue -
                          sizes.schemeSelectedPercent -
                          sizes.schemeDeparturePercent)
                      .clamp(0.0, sizes.schemeArrivalPercent) /
                  sizes.schemeArrivalPercent);
              arrivalStation.add(selectedTrain.to);
            }
          } else //Collapsing from current train to none
          {
            trainClass.add(currentTrain.trainClass);

            if (!currentTrain.arrivalSelected) {
              arrivalValue.add(1 -
                  (collapsingValue.clamp(0.0, sizes.schemeArrivalPercent) /
                      sizes.schemeArrivalPercent));
              arrivalStation.add(currentTrain.to);
            }

            arrivalIconValue.add(1 -
                ((collapsingValue -
                            sizes.schemeArrivalPercent +
                            sizes.schemeIconPercent / 2)
                        .clamp(0.0, sizes.schemeIconPercent) /
                    sizes.schemeIconPercent));
            arrivalSelected.add(currentTrain.arrivalSelected);

            selectedValue.add(1 -
                ((collapsingValue - sizes.schemeArrivalPercent)
                        .clamp(0.0, sizes.schemeSelectedPercent) /
                    sizes.schemeSelectedPercent));

            departureIconValue.add(1 -
                ((collapsingValue -
                            sizes.schemeArrivalPercent -
                            sizes.schemeSelectedPercent +
                            sizes.schemeIconPercent / 2)
                        .clamp(0.0, sizes.schemeIconPercent) /
                    sizes.schemeIconPercent));
            departureSelected.add(currentTrain.departureSelected);

            if (!currentTrain.departureSelected) {
              departureValue.add(1 -
                  ((collapsingValue -
                              sizes.schemeSelectedPercent -
                              sizes.schemeArrivalPercent)
                          .clamp(0.0, sizes.schemeDeparturePercent) /
                      sizes.schemeDeparturePercent));
              departureStation.add(currentTrain.from);
            }
          }
        }
      }
    });
  }

  close() {
    valueInputStream.close();

    selectedTrainInputStream.close();
    currentTrainInputStream.close();

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
