//import 'package:flutter/material.dart';
//import 'package:trains/data/stop.dart';
//
//enum TrainType { suburban, lastm, last }
//
//class Thread {
//  TrainType type;
//  String uid;
//  List<Color> colors = [];
//  List<Stop> stops = [];
//
//  Thread(this.type, this.stops) {
//    _getColors();
//  }
//
//  void _getColors() {
//    colors.clear();
//    switch (type.toString().replaceAll("TrainType.", "")) {
//      case 'last':
//        {
//          colors.add(Colors.red[200]);
//          colors.add(Colors.red[100]);
//          break;
//        }
//      case 'lastm':
//        {
//          colors.add(Colors.green[200]);
//          colors.add(Colors.green[100]);
//          break;
//        }
//      case 'suburban':
//        {
//          colors.add(Colors.grey[350]);
//          colors.add(Colors.grey[200]);
//          break;
//        }
//    }
//  }
//
//  Thread.fromMap(Map<String, dynamic> map) {
//    switch (map['transport_subtype']['code']) {
//      case 'last':
//        {
//          type = TrainType.last;
//          break;
//        }
//      case 'lastm':
//        {
//          type = TrainType.lastm;
//          break;
//        }
//      default:
//        {
//          type = TrainType.suburban;
//          break;
//        }
//    }
//    _getColors();
//    List<dynamic> _list = map['stops'];
//    for (int i = 0; i < _list.length; i++) {
//      var _stop = Stop.fromDynamic(_list.elementAt(i));
//      if ((i == 0 ||
//          i == _list.length - 1 ||
//          _stop.stopTime != null && _stop.stopTime.inSeconds > 0))
//        stops.add(_stop);
//    }
//  }
//
//  Duration _howSoon(DateTime time) {
//    return time.difference(DateTime.now().toLocal());
//  }
//}
