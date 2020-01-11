import 'package:rxdart/rxdart.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/classes/trainclass.dart';

class TrainClassesBloc {
  TrainClassesBloc({Stream<List<Train>> trains}) {
    excludedTypes.add(List<TrainType>());
    classes.add(List<TrainClass>());
    trains.listen((list) => init(list));
  }

  init(List<Train> trains) {
    if (trains.isEmpty)
      reset();
    else {
      final map = Map<TrainType, int>();
      trains.forEach((train) {
        if (!map.containsKey(train.type)) {
          map[train.type] = train.price;
        }
      });
      final list = List<TrainClass>();
      map.forEach((type, price) {
        final oldClasses = classes.value
            .where((trainClass) => trainClass.type == type)
            .toList();
        final newClass = TrainClass(type: type, price: price);
        newClass.selected =
            oldClasses.isNotEmpty ? oldClasses.first.selected : true;
        list.add(newClass);
      });
      classes.add(list);
    }
  }

  reset() {
    excludedTypes.add(List<TrainType>());
    classes.add(List<TrainClass>());
  }

  update(TrainType type) {
    final types = excludedTypes.value;
    final currentClasses = classes.value;
    if (types.contains(type)) {
      types.remove(type);
      currentClasses.firstWhere((trainClass) => trainClass.type == type).selected =
          true;
    } else if (types.length < currentClasses.length - 1) {
      types.add(type);
      currentClasses.firstWhere((trainClass) => trainClass.type == type).selected =
          false;
    }
    excludedTypes.add(types);
    classes.add(currentClasses);
  }

  final classes = BehaviorSubject<List<TrainClass>>();

  final excludedTypes = BehaviorSubject<List<TrainType>>();

  close() {
    classes.close();
    excludedTypes.close();
  }
}
