//import 'package:flutter/material.dart';
//
//class ClipTrain extends CustomClipper<Path> {
//  @override
//  ClipTrain(this._topConstrain, this._bottomConstrain);
//
//  double _topConstrain;
//  double _bottomConstrain;
//
//  Path getClip(Size size) {
//    var path = Path();
//    path.lineTo(size.width * _topConstrain, 0.0);
//    path.lineTo(size.width * _bottomConstrain, size.height);
//    path.lineTo(size.width, size.height);
//    path.lineTo(size.width, 0.0);
//
//    // TODO: implement getClip
//    return path;
//  }
//
//  @override
//  bool shouldReclip(CustomClipper<Path> oldClipper) {
//    // TODO: implement shouldReclip
//    return oldClipper != this;
//  }
//}
