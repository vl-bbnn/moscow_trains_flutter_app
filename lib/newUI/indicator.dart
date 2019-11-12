import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/newData/classes/train.dart';

class Indicator extends StatelessWidget {
  final Train train;
  final width;
  final height;

  Indicator({Key key, this.train, this.width, this.height}) {}

  Widget _background() {
    return Container(
      height: height,
      width: width,
      alignment: Alignment.center,
      child: Container(
        width: width * 0.75,
        decoration: ShapeDecoration(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          color: Constants.BLACK,
        ),
      ),
    );
  }

  Widget _path() {
    final color = _colorSwitch();
    final height = _pathHeight();
    return Stack(
      children: <Widget>[
        Container(
          height: height,
          width: width,
          decoration: ShapeDecoration(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(width / 2)),
              color: color,
              shadows: [
                BoxShadow(color: color, blurRadius: 20, spreadRadius: 1)
              ]),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          child: Container(
            child: Stack(
              children: <Widget>[
                Container(
                  height: height,
                  width: width / 2,
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(width / 4),
                              bottomRight: Radius.circular(width / 4))),
                      color: Colors.white.withOpacity(0.05),
                      shadows: [
                        BoxShadow(
                            color: Colors.white.withOpacity(0.05),
                            blurRadius: 20,
                            spreadRadius: 1)
                      ]),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Color _colorSwitch() {
    switch (train.type) {
      case TrainType.express:
        return Constants.EXPRESS;
      case TrainType.comfort:
        return Constants.COMFORT;
      default:
        return Constants.REGULAR;
    }
  }

  double _position() {
    if (train.isGoingFromFirstStation)
      return 0.0;
    else
      return height * 0.33;
  }

  double _pathHeight() {
    if (train.isGoingFromFirstStation && train.isGoingToLastStation)
      return height;
    else if (train.isGoingFromFirstStation || train.isGoingToLastStation)
      return height * 0.66;
    else
      return height * 0.33;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      child: Stack(
        children: <Widget>[
          _background(),
          Positioned(
            child: _path(),
            left: 0,
            right: 0,
            top: _position(),
          ),
        ],
      ),
    );
  }
}
