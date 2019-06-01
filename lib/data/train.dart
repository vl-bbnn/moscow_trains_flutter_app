import 'package:flutter/material.dart';

enum TrainType { suburban, lastm, last }

class Train {
  DateTime departure = DateTime.now();
  DateTime arrival;
  TrainType type;
  int price = 0;
  String uid;
  String from;
  String to;
  bool isLast = false;
  bool isGoingFromFirstStation = false;
  bool isGoingToLastStation = false;
  List<Color> colors = [Colors.grey[350]];

  Train(this.type, this.departure, this.arrival, this.price, this.uid,
      this.from, this.to) {
    _getColors();
  }

  void _getColors() {
    colors.clear();
    switch (type.toString().replaceAll("TrainType.", "")) {
      case 'last':
        {
          colors.add(Colors.red[200]);
          colors.add(Colors.red[100]);
          break;
        }
      case 'lastm':
        {
          colors.add(Colors.green[200]);
          colors.add(Colors.green[100]);
          break;
        }
      case 'suburban':
        {
          colors.add(Colors.grey[350]);
          colors.add(Colors.grey[200]);
          break;
        }
    }
  }

  Train.fromDynamic(dynamic object) {
    String _title = object['title'];
    from = _title.split('—')[0].trim();
    to = _title.split('—')[1].trim();
    uid = object['uid'];
    departure = DateTime.parse(object['departure']).toLocal();
    arrival = DateTime.parse(object['arrival']).toLocal();
    isLast = object['isLast'];
    switch (object['type']) {
      case 'last':
        {
          type = TrainType.last;
          break;
        }
      case 'lastm':
        {
          type = TrainType.lastm;
          break;
        }
      default:
        {
          type = TrainType.suburban;
          break;
        }
    }
    _getColors();
    if (!departure.difference(DateTime.now().toLocal()).isNegative)
      price = object['price'];
  }
}
