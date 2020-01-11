import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/my_types_icons.dart';

class Class extends StatelessWidget {
  final TrainType type;
  final bool selected;

  const Class({Key key, @required this.type, this.selected}) : super(key: key);

  _label() {
    switch (type) {
      case TrainType.regular:
        return Icon(
          (selected) ? MyTypes.standart_selected : MyTypes.standart_deselected,
          color: Constants.REGULAR,
        );
      case TrainType.comfort:
        return Icon(
          (selected) ? MyTypes.comfort_black : MyTypes.comfort_deselected,
          color: Constants.COMFORT,
        );
      case TrainType.express:
        return Icon(
          (selected) ? MyTypes.express_selected : MyTypes.express_deselected,
          color: Constants.EXPRESS,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      height: 24,
      child: _label(),
    );
  }
}
