import 'package:rxdart/rxdart.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/classes/trainclassfilter.dart';

class TrainClassesBloc {
  TrainClassesBloc({Stream<List<Train>> trains}) {
    excludedTypes.add(List<TrainClass>());
    classes.add(List<TrainClassFilter>());
    trains.listen((list) => init(list));
  }

  init(List<Train> trains) {
    if (trains.isEmpty)
      reset();
    else {
      final map = Map<TrainClass, int>();
      trains.forEach((train) {
        if (!map.containsKey(train.trainClass)) {
          map[train.trainClass] = train.price;
        }
      });
      final list = List<TrainClassFilter>();
      map.forEach((type, price) {
        final oldClasses = classes.value
            .where((trainClass) => trainClass.trainClass == type)
            .toList();
        final newClass = TrainClassFilter(trainClass: type, price: price);
        newClass.selected =
            oldClasses.isNotEmpty ? oldClasses.first.selected : true;
        list.add(newClass);
      });
      classes.add(list);
    }
  }

  reset() {
    excludedTypes.add(List<TrainClass>());
    classes.add(List<TrainClassFilter>());
  }

  update(TrainClass type) {
    final types = excludedTypes.value;
    final currentClasses = classes.value;
    if (types.contains(type)) {
      types.remove(type);
      currentClasses.firstWhere((trainClass) => trainClass.trainClass == type).selected =
          true;
    } else if (types.length < currentClasses.length - 1) {
      types.add(type);
      currentClasses.firstWhere((trainClass) => trainClass.trainClass == type).selected =
          false;
    }
    excludedTypes.add(types);
    classes.add(currentClasses);
  }

  final classes = BehaviorSubject<List<TrainClassFilter>>();

  final excludedTypes = BehaviorSubject<List<TrainClass>>();

  close() {
    classes.close();
    excludedTypes.close();
  }
}
