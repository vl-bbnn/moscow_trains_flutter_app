//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:trains/data/train.dart';
//
//class TrainSmallCard extends StatelessWidget {
//  TrainSmallCard(this.train);
//
//  final Train train;
//
//  Duration _howSoon(DateTime time) {
//    return time.difference(DateTime.now().toLocal());
//  }
//
//  Widget _howMuchLeft() {
//    var _minutes = _howSoon(train.departure).inMinutes;
//    if (_minutes < 0 || _minutes > 60) return Container();
//    if (_minutes == 0) return Text("сейчас");
//    var _color = Colors.black;
//    if (_minutes < 10) _color = Colors.red;
////    if (_minutes < 60)
//    return Text(
//      "через $_minutes м",
//      style: TextStyle(color: _color),
//    );
////    var _hours = (_minutes / 60).floor();
////    _minutes %= 60;
////    return Text("через $_hours ч $_minutes мин");
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      width: 120.0,
//      child: Material(
//        elevation: 4.0,
//        color: Colors.white,
//        borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0)),
//        child: Container(
////                color: Colors.amber,
//          width: MediaQuery.of(context).size.width * 0.25,
//          child: Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              _howMuchLeft(),
//              Container(
//                padding: EdgeInsets.all(4.0),
////                            width: MediaQuery.of(context).size.width * 0.25,
//                child: Text(
//                  DateFormat('kk:mm').format(train.departure),
//                  style: TextStyle(
//                      fontSize: 22.0,
//                      fontWeight: FontWeight.w700,
//                      color: !_howSoon(train.departure).isNegative &&
//                              _howSoon(train.departure).abs().inMinutes <= 10
//                          ? Colors.red
//                          : Colors.black),
//                ),
//              ),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
