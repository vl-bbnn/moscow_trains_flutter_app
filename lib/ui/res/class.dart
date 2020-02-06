import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';

class Class extends StatelessWidget {
  final TrainClass type;
  final bool selected;

  const Class({Key key, @required this.type, this.selected}) : super(key: key);

  _icon() {
    switch (type) {
      case TrainClass.regular:
        return SvgPicture.asset(
          'assets/trainClasses/standart.svg',
          semanticsLabel: 'standart',
          color: Constants.REGULAR,
        );
      case TrainClass.comfort:
        return SvgPicture.asset(
          'assets/trainClasses/comfort.svg',
          semanticsLabel: 'comfort',
          color: Constants.COMFORT,
        );
      case TrainClass.express:
        return SvgPicture.asset(
          'assets/trainClasses/express.svg',
          semanticsLabel: 'express',
          color: Constants.EXPRESS,
        );
      default:
        return SvgPicture.asset(
          'assets/trainClasses/d3.svg',
          semanticsLabel: 'd3-white',
          color: Constants.WHITE,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 24,
      child: _icon(),
    );
  }
}
