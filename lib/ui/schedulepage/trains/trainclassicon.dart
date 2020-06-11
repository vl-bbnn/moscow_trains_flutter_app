import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';

class TrainClassIcon extends StatelessWidget {
  final TrainClass trainClass;
  final double angle;
  final double frontOpacity;
  final double frontWidth;
  final double frontHeight;
  final double backWidth;
  final double backHeight;
  final double backSigma;

  const TrainClassIcon(
      {Key key,
      this.trainClass,
      this.angle,
      this.frontOpacity,
      this.backSigma,
      this.frontWidth,
      this.frontHeight,
      this.backWidth,
      this.backHeight})
      : super(key: key);

  Image _labeledIcon() {
    switch (trainClass) {
      case TrainClass.standart:
        return Image.asset("assets/types/st.png");
      case TrainClass.comfort:
        return Image.asset("assets/types/cm.png");
      case TrainClass.express:
        return Image.asset("assets/types/ex.png");
    }
    return Image.asset("assets/types/st.png");
  }

  Image _emptyIcon() {
    switch (trainClass) {
      case TrainClass.standart:
        return Image.asset("assets/types/st_notext.png");
      case TrainClass.comfort:
        return Image.asset("assets/types/cm_notext.png");
      case TrainClass.express:
        return Image.asset("assets/types/ex_notext.png");
    }
    return Image.asset("assets/types/st_notext.png");
  }

  @override
  Widget build(BuildContext context) {
    final bottomIcon = _labeledIcon();
    final topIcon = _emptyIcon();

    return Transform.rotate(
      angle: angle,
      child: SizedBox(
        width: frontWidth,
        height: frontHeight,
        child: Stack(
          children: <Widget>[
            bottomIcon,
            // BackdropFilter(
            //   filter: ImageFilter.blur(sigmaX: backSigma, sigmaY: backSigma),
            //   child: Container(
            //     color: Colors.black.withOpacity(0),
            //   ),
            // ),
            Opacity(
              opacity: frontOpacity,
              child: topIcon,
            )
          ],
        ),
      ),
    );
    // return Container(
    //   width: Helper.width(glowSize, size),
    //   height: Helper.height(glowSize, size),
    //   decoration: ShapeDecoration(
    //       shape: CircleBorder(),
    //       color: (_color() as Color).withOpacity(0.25),
    //       shadows: [
    //         // BoxShadow(
    //         //     color: _color(),
    //         //     blurRadius: glowSize - dotDize,
    //         //     spreadRadius: glowSize - dotDize)
    //       ]),
    //   child: Center(
    //     child: Container(
    //       width: Helper.width(dotDize, size),
    //       height: Helper.height(dotDize, size),
    //       decoration:
    //           ShapeDecoration(shape: CircleBorder(), color: _color(), shadows: [
    //         // BoxShadow(
    //         //     color: _color(),
    //         //     blurRadius: glowSize - dotDize,
    //         //     spreadRadius: glowSize - dotDize)
    //       ]),
    //     ),
    //   ),
    // );
  }
}
