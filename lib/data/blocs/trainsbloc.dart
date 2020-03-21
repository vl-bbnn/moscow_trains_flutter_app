import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/src/helper.dart';

class TrainsBloc {
  BehaviorSubject<Status> status;
  BehaviorSubject<DateTime> dateTime;
  BehaviorSubject<List<Train>> allTrains;

  var trains = List<Train>();
  final results = BehaviorSubject.seeded(List<Train>());
  final selected = BehaviorSubject<Train>();
  final index = BehaviorSubject.seeded(0);

  init({newStatus, newDateTime, newAllTrains}) {
    status = newStatus;
    dateTime = newDateTime;
    allTrains = newAllTrains;
    status.listen((newStatus) {
      if (newStatus != Status.found) results.add(List<Train>());
    });
    allTrains.listen((newTrains) {
      if (newTrains.isNotEmpty) _trimTrains(newTrains);
    });
    dateTime.listen((newDateTime) {
      if (trains.isNotEmpty) _trimTrains(trains);
    });
  }

  TrainsBloc() {
    index.listen((newIndex) {
      if (results.value.isNotEmpty) {
        // print("newIndex: " + newIndex.toString());
        selected.add(results.value.elementAt(newIndex));
      }
    });
    results.listen((newTrains) {
      if (selected.value != null) {
        final newIndex =
            newTrains.indexWhere((train) => train.uid == selected.value.uid);
        if (newIndex > 0)
          index.add(newIndex);
        else
          index.add(0);
      } else
        index.add(0);
    });
  }

  _trimTrains(List<Train> list) {
    if (list.first.departure.isBefore(dateTime.value)) {
      final index =
          list.indexWhere((train) => train.departure.isAfter(dateTime.value));
      if (index >= 0) {
        final newList = list.sublist(index);
        trains = newList;
      } else
        status.add(Status.notFound);
    } else {
      trains = list;
    }
    _updateResults();
  }

  _setWarnings() {
    final list = results.value;
    list.asMap().forEach((index, train) {
      train.timeDiffToPrevTrain = index > 0
          ? Helper.timeDiffInMins(
              train.departure, list.elementAt(index - 1).departure)
          : 0;
      train.timeDiffToTarget =
          Helper.timeDiffInMins(train.departure, dateTime.value);
      if (index == list.length - 1) train.isLast = true;
    });
    results.add(list);
  }

  _updateResults() {
    if (trains.isNotEmpty) {
      results.add(trains);
      _setWarnings();
      if (status.value != Status.found) status.add(Status.found);
    } else
      status.add(Status.notFound);
  }

  prev() {
    if (index.value > 0) index.add(index.value - 1);
  }

  next() {
    if (index.value < results.value.length - 1) index.add(index.value + 1);
  }

  select(newIndex) {
    if (newIndex >= 0 && newIndex <= results.value.length) index.add(newIndex);
  }

  close() {
    results.close();
    status.close();
    dateTime.close();
    selected.close();
    index.close();
  }
}
