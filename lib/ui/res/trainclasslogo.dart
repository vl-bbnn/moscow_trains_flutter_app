import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/res/mycolors.dart';

class TrainClassLogo extends StatelessWidget {
  final TrainClass type;
  final bool selected;

  const TrainClassLogo({Key key, @required this.type, this.selected}) : super(key: key);

  _icon() {
    switch (type) {
      case TrainClass.regular:
        return SvgPicture.asset(
          'assets/types/st.svg',
          semanticsLabel: 'standart',
          color: MyColors.REGULAR,
        );
      case TrainClass.comfort:
        return SvgPicture.asset(
          'assets/types/cm.svg',
          semanticsLabel: 'comfort',
          color: MyColors.COMFORT,
        );
      case TrainClass.express:
        return SvgPicture.asset(
          'assets/types/ex.svg',
          semanticsLabel: 'express',
          color: MyColors.EXPRESS,
        );
      default:
        return SvgPicture.asset(
          'assets/types/d3.svg',
          semanticsLabel: 'd3-white',
          color: MyColors.BLACK,
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
