//import 'dart:math';
//
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:trains/drafts/cliptrain.dart';
//import 'package:trains/data/train.dart';
//
//class TrainCard extends StatelessWidget {
//  TrainCard(@required this.train);
//
//  final Train train;
//
//  int _howLong;
//  List<Color> _colors = [Colors.grey[350]];
//
//  double _cardListHeight = 100.0;
//  double _topConstrain = 0.15;
//  double _bottomConstrain = 0.1;
//
//  void _getColors() {
//    _colors.clear();
//    switch (train.type.toString().replaceAll("TrainType.", "")) {
//      case 'last':
//        {
//          _colors.add(Colors.red[200]);
//          _colors.add(Colors.red[100]);
//          break;
//        }
//      case 'lastm':
//        {
//          _colors.add(Colors.green[200]);
//          _colors.add(Colors.green[100]);
//          break;
//        }
//      case 'suburban':
//        {
//          _colors.add(Colors.grey[350]);
//          _colors.add(Colors.grey[200]);
//          break;
//        }
//    }
//  }
//
//  Duration _howSoon(DateTime time) {
//    return time.difference(DateTime.now().toLocal());
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    _howLong = train.arrival.difference(train.departure).inMinutes;
//    _getColors();
//    return Container(
//      padding: const EdgeInsets.all(4.0),
//      child: Opacity(
//        opacity: !_howSoon(train.departure).isNegative ? 1.0 : 0.5,
//        child: Stack(
//          children: <Widget>[
//            Positioned(
//              top: 4.0,
//              child: Container(
//                padding: EdgeInsets.only(right: 12.0),
//                height: _cardListHeight,
//                width: MediaQuery.of(context).size.width,
//                child: Card(
//                  color: _colors.length != 0
//                      ? _colors.elementAt(0)
//                      : Colors.grey[350],
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
//                  child: Container(
//                    padding: EdgeInsets.symmetric(horizontal: 8.0),
//                    alignment: Alignment.centerLeft,
//                    child: train.price != 0
//                        ? RotatedBox(
//                            quarterTurns: 3,
//                            child: Text(
//                              "${train.price} ₽",
//                              style: TextStyle(
//                                  fontWeight: FontWeight.w800,
//                                  fontSize: 24.0,
//                                  color: Colors.black),
//                            ),
//                          )
//                        : Container(),
//                  ),
//                ),
//              ),
//            ),
//            ClipPath(
//              clipper: ClipTrain(_topConstrain, _bottomConstrain),
//              child: Card(
//                color: Colors.red,
//                elevation: 4.0,
//                child: Container(
//                  padding: EdgeInsets.only(
//                      left: MediaQuery.of(context).size.width *
//                          max(_topConstrain, _bottomConstrain),
//                      right: 8.0,
//                      top: 8.0,
//                      bottom: 8.0),
//                  height: _cardListHeight,
//                  child: Column(
//                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                    children: <Widget>[
//                      Row(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
////                          Padding(
////                            padding: const EdgeInsets.only(right: 4.0),
////                            child: _howMuchLeft(train.departure),
////                          ),
//                          Container(
//                            alignment: Alignment.centerLeft,
////                            width: MediaQuery.of(context).size.width * 0.25,
//                            child: Text(
//                              DateFormat('kk:mm').format(train.departure),
//                              style: TextStyle(
//                                  fontSize: 26.0,
//                                  fontWeight: FontWeight.w900,
//                                  color:
//                                      !_howSoon(train.departure).isNegative &&
//                                              _howSoon(train.departure)
//                                                      .abs()
//                                                      .inMinutes <=
//                                                  10
//                                          ? Colors.red
//                                          : Colors.black),
//                            ),
//                          ),
//                          Container(
//                            child: Text(
//                              "$_howLong мин",
//                              style: TextStyle(fontSize: 14.0),
//                            ),
//                          ),
////                          Container(
////                            padding: EdgeInsets.symmetric(horizontal: 8.0),
////                            alignment: Alignment.center,
////                            child: _indicator(segment),
////                          ),
//                          Container(
//                            alignment: Alignment.centerRight,
////                            width: MediaQuery.of(context).size.width * 0.25,
//                            child: Text(
//                                DateFormat('kk:mm').format(train.arrival),
//                                style: TextStyle(
//                                    fontSize: 26.0,
//                                    fontWeight: FontWeight.w900)),
//                          ),
//                        ],
//                      ),
////                      Row(
////                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
////                        children: <Widget>[
////                          Container(
////                            alignment: Alignment.centerLeft,
////                            child: Text(
////                              train.fromStationCode.name,
////                              style: TextStyle(
////                                  fontSize: 18.0, fontWeight: FontWeight.w600),
////                            ),
////                          ),
////                          Container(
////                            alignment: Alignment.centerLeft,
////                            child: Text(
////                              train.toStationCode.name,
////                              style: TextStyle(
////                                  fontSize: 18.0, fontWeight: FontWeight.w600),
////                            ),
////                          ),
////                        ],
////                      ),
//                    ],
//                  ),
//                ),
//              ),
//            ),
//          ],
//        ),
//      ),
//    );
//  }
//}
