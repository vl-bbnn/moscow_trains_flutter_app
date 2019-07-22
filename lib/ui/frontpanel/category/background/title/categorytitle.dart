import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';

class CategoryTitle extends StatelessWidget {
  CategoryTitle({@required this.type});
  final TrainType type;

  _typeName(TrainType type) {
    switch (type) {
      case TrainType.suburban:
        return "Стандарт";
      case TrainType.lastm:
        return "Комфорт";
      case TrainType.last:
        return "Экспресс";
      default:
        return "Не определен";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Text(
        _typeName(type),
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: Constants.TEXT_SIZE_BIG,
            color: Constants.whiteHigh),
      ),
    );
  }
}
