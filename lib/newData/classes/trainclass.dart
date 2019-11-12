import 'package:trains/newData/classes/train.dart';

class TrainClass {
  String name;
  final TrainType type;
  int price;
  bool selected = true;

  _name() {
    switch (type) {
      case TrainType.regular:
        return "Стандарт";
      case TrainType.comfort:
        return "Комфорт";
      case TrainType.express:
        return "Экспресс";
      default:
        return "Все";
    }
  }

  TrainClass({this.type, this.price}) {
    this.name = _name();
  }
}
