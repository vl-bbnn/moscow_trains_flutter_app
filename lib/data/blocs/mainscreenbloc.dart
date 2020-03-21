import 'package:rxdart/subjects.dart';
import 'package:trains/data/classes/train.dart';

class MainScreenBloc {
  final map = BehaviorSubject.seeded(Map<String, dynamic>());
  final bottomOffset = BehaviorSubject.seeded(0.0);
  final topOffset = BehaviorSubject.seeded(0.0);

  updateSelectedTrain(Train train) {
    final oldMap = map.value;
    oldMap['trainOriginStation'] = train.from.title;
    oldMap['trainDestinationStation'] = train.to.title;
    oldMap['selectedOrigin'] = train.fromSelected;
    oldMap['selectedDestination'] = train.toSelected;
    map.add(oldMap);
  }

  updateTop(newTop) {
    final oldMap = map.value;
    oldMap['departureTopOffset'] = newTop;
    map.add(oldMap);
  }

  updateBottom(newBottom) {
    final oldMap = map.value;
    oldMap['arrivalBottomOffset'] = newBottom;
    map.add(oldMap);
  }

  updateStops(top, bottom) {
    final oldMap = map.value;
    oldMap['topOfTrainDetails'] = top;
    oldMap['bottomOfTrainDetails'] = bottom;
    map.add(oldMap);
  }

  updateStatus(status) {
    final oldMap = map.value;
    oldMap['status'] = status;
    map.add(oldMap);
  }

  updateFrom(fromStation) {
    final oldMap = map.value;
    oldMap['fromStation'] = fromStation;
    map.add(oldMap);
  }

  updateTo(toStation) {
    final oldMap = map.value;
    oldMap['toStation'] = toStation;
    map.add(oldMap);
  }

  updateBottomOffset(offset) {
    final oldMap = map.value;
    oldMap['bottomOffset'] = offset;
    map.add(oldMap);
    bottomOffset.add(offset);
  }

  updateTopOffset(offset) {
    final oldMap = map.value;
    oldMap['topOffset'] = offset;
    map.add(oldMap);
    topOffset.add(offset);
  }

  close() {
    map.close();
    bottomOffset.close();
    topOffset.close();
  }
}
