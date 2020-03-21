import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/res/mycolors.dart';

class TrainClassLogo extends StatelessWidget {
  final TrainClass trainClass;
  final bool colored;
  final double height;
  final double width;

  const TrainClassLogo(
      {this.trainClass, this.colored = true, this.height = 24.0, this.width})
      : assert(trainClass != null);

  _icon() {
    switch (trainClass) {
      case TrainClass.regular:
        return SvgPicture.asset(
          'assets/types/st.svg',
          semanticsLabel: 'standart',
          color: colored ? MyColors.REGULAR : MyColors.PRIMARY_BACKGROUND,
        );
      case TrainClass.comfort:
        return SvgPicture.asset(
          'assets/types/cm.svg',
          semanticsLabel: 'comfort',
          color: colored ? MyColors.COMFORT : MyColors.PRIMARY_BACKGROUND,
        );
      case TrainClass.express:
        return SvgPicture.asset(
          'assets/types/ex.svg',
          semanticsLabel: 'express',
          color: colored ? MyColors.EXPRESS : MyColors.PRIMARY_BACKGROUND,
        );
      default:
        return SvgPicture.asset(
          'assets/types/d3.svg',
          semanticsLabel: 'd3-white',
          color: MyColors.PRIMARY_BACKGROUND,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width == null ? height * 2 : width,
      height: width == null ? height : width / 2,
      child: _icon(),
    );
  }
}
