import 'package:flutter/material.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';

class TrainDot extends StatelessWidget {
  final train;
  final curvedValue;
  final Sizes sizes;

  const TrainDot({Key key, this.train, this.curvedValue: 0.0, this.sizes})
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
    final dotDize = sizes.regularTrainIconSize +
        curvedValue *
            (sizes.selectedTrainIconSize - sizes.regularTrainIconSize);
    final glowSize = sizes.regularTrainIconGlow +
        curvedValue *
            (sizes.selectedTrainIconGlow - sizes.regularTrainIconGlow);
            
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
