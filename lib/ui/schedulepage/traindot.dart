import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/mysizes.dart';

class TrainDot extends StatelessWidget {
  final train;
  final curvedValue;

  const TrainDot({Key key, this.train, this.curvedValue: 0.0})
      : super(key: key);

  _color() {
    if (train != null)
      switch (train.trainClass) {
        case TrainClass.standart:
          return MyColors.ST;
        case TrainClass.comfort:
          return MyColors.D3;
        case TrainClass.express:
          return MyColors.EX;
      }
    return MyColors.WA;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dotDize = RegularTrainSizes.DOT_SIZE +
        curvedValue *
            (SelectedTrainSizes.DOT_SIZE - RegularTrainSizes.DOT_SIZE);
    final glowSize = RegularTrainSizes.DOT_GLOW +
        curvedValue *
            (SelectedTrainSizes.DOT_GLOW - RegularTrainSizes.DOT_GLOW);
    return Container(
      width: Helper.width(glowSize, size),
      height: Helper.height(glowSize, size),
      decoration: ShapeDecoration(
          shape: CircleBorder(),
          color: (_color() as Color).withOpacity(0.25),
          shadows: [
            // BoxShadow(
            //     color: _color(),
            //     blurRadius: glowSize - dotDize,
            //     spreadRadius: glowSize - dotDize)
          ]),
      child: Center(
        child: Container(
          width: Helper.width(dotDize, size),
          height: Helper.height(dotDize, size),
          decoration:
              ShapeDecoration(shape: CircleBorder(), color: _color(), shadows: [
            // BoxShadow(
            //     color: _color(),
            //     blurRadius: glowSize - dotDize,
            //     spreadRadius: glowSize - dotDize)
          ]),
        ),
      ),
    );
  }
}
