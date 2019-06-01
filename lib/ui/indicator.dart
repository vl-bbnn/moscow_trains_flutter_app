import 'package:flutter/material.dart';
import 'package:trains/src/dotsindicator.dart';
import 'package:trains/data/train.dart';

class Indicator extends StatelessWidget {
  Indicator(this.train);
  final Train train;

  int _numberOfDots = 3;
  int _activeDot = 0;
  double _dotActiveLength = 10.0;
  ShapeBorder _dotActiveShape =
      RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0));

  void define() {
    if (train.isGoingFromFirstStation && train.isGoingToLastStation) {
      _numberOfDots = 1;
      _dotActiveLength *= 4.5;
    } else if (train.isGoingFromFirstStation) {
      _numberOfDots = 2;
      _dotActiveLength *= 2.5;
      _activeDot = 0;
    } else if (train.isGoingToLastStation) {
      _numberOfDots = 2;
      _dotActiveLength *= 2.5;
      _activeDot = 1;
    } else {
      _activeDot = 1;
      _dotActiveShape = CircleBorder();
    }
  }

  @override
  Widget build(BuildContext context) {
    define();
    return DotsIndicator(
        numberOfDot: _numberOfDots,
        dotActiveColor: train.colors.elementAt(0),
        dotActiveSize: Size(_dotActiveLength, 10.0),
        dotSize: Size.square(5.0),
        position: _activeDot,
        dotActiveShape: _dotActiveShape);
  }
}
