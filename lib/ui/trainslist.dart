import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/ui/indicator.dart';
import 'package:trains/data/train.dart';

class TrainCard extends StatelessWidget {
  TrainCard(@required this.train);

  final Train train;

  int _howLong;
  List<Color> _colors = [Colors.grey[350]];

  void _getColors() {
    _colors.clear();
    switch (train.type.toString().replaceAll("TrainType.", "")) {
      case 'last':
        {
          _colors.add(Colors.red[200]);
          _colors.add(Colors.red[100]);
          break;
        }
      case 'lastm':
        {
          _colors.add(Colors.green[200]);
          _colors.add(Colors.green[100]);
          break;
        }
      case 'suburban':
        {
          _colors.add(Colors.grey[350]);
          _colors.add(Colors.grey[200]);
          break;
        }
    }
  }

  Duration _howSoon(DateTime time) {
    return time.difference(DateTime.now().toLocal());
  }

  Widget _howMuchLeft() {
    var minutes = _howSoon(train.departure).inMinutes;
    if (minutes < 0 || minutes > 60) return Container();
    var _color = Colors.black;
    if (minutes < 15) _color = Colors.red;
    var _text = minutes > 0 ? "через\n" + _timeString(minutes) : "сейчас";
    return Text(
      _text,
      style: TextStyle(color: _color),
      textAlign: TextAlign.end,
    );
  }

  String _timeString(minutes) {
    if (minutes < 60) return "$minutes мин";
    var _hours = (minutes / 60).floor();
    var _minutes = minutes % 60;
    return "$_hours ч $_minutes мин";
  }

  Widget _price() {
    return train.price != 0
        ? Card(
            elevation: 0.0,
            color:
                _colors.length != 0 ? _colors.elementAt(0) : Colors.grey[350],
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Center(
                  child: Text(
                "${train.price} ₽",
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18.0,
                    color: Colors.black),
              )),
            ),
          )
        : Container();
  }

  @override
  Widget build(BuildContext context) {
    _howLong = train.arrival.difference(train.departure).inMinutes;
    _getColors();
    return Material(
      color: Colors.white,
      shape: Border.all(width: 0.0, color: Colors.white),
      elevation: 0.0,
      child: Opacity(
        opacity: !_howSoon(train.departure).isNegative ? 1.0 : 0.5,
        child: Container(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//                  Container(
//                    alignment: AlignmentDirectional.centerEnd,
//                    width: MediaQuery.of(context).size.width * 0.2,
//                    child: Container(
//                      padding: EdgeInsets.all(4.0),
//                      child: _howMuchLeft(),
//                    ),
//                  ),
                  Container(
//                color: Colors.amber,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Container(
//                            width: MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        DateFormat('kk:mm').format(train.departure),
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            fontSize: 26.0,
                            fontWeight: FontWeight.w700,
                            color: !_howSoon(train.departure).isNegative &&
                                    _howSoon(train.departure).abs().inMinutes <=
                                        15
                                ? Colors.red
                                : Colors.black),
                      ),
                    ),
                  ),
                  Container(
//                color: Colors.greenAccent,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.all(4.0),
                          child: Text(
                            _timeString(_howLong),
                            style: TextStyle(fontSize: 14.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
//                color: Colors.amber,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Container(
//                            width: MediaQuery.of(context).size.width * 0.25,
                      child: Text(
                        DateFormat('kk:mm').format(train.arrival),
                        style: TextStyle(
                            fontSize: 26.0, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
//                  Container(
////                color: Colors.indigo,
//                    width: MediaQuery.of(context).size.width * 0.2,
//                    child: Column(
//                      crossAxisAlignment: CrossAxisAlignment.center,
//                      children: <Widget>[
//                        _price(),
//                      ],
//                    ),
//                  ),
                  Container(
                    alignment: AlignmentDirectional.centerEnd,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(train.from),
                  ),
                  Container(
                    alignment: AlignmentDirectional.center,
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Indicator(train),
                  ),
                  Container(
                    alignment: AlignmentDirectional.centerStart,
                    width: MediaQuery.of(context).size.width * 0.35,
                    child: Text(train.to),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
