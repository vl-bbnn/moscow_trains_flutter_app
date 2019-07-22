import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';

class TrainIndicator extends StatelessWidget {
  final Train train;
  final double width = 6.0;
  final selected;
  const TrainIndicator({Key key, this.train, this.selected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        _line(),
        _indicators(),
      ],
    );
  }

  Widget _indicators() {
    List<Widget> list = new List();
    if (train.isGoingFromFirstStation)
      list.addAll([_selectedDot(), _emptyDot()]);
    else
      list.addAll([_emptyDot(), _selectedDot()]);
    if (train.isGoingToLastStation)
      list.addAll([_emptyDot(), _selectedDot()]);
    else
      list.addAll([_selectedDot(), _emptyDot()]);
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: list,
    );
  }

  _emptyDot() => Container(
        margin: EdgeInsets.all(width / 2),
        width: width,
        height: width,
      );

  _selectedDot() => Container(
        margin: EdgeInsets.all(width / 2),
        width: width,
        height: width,
        decoration: ShapeDecoration(
            shape: CircleBorder(),
            color: selected ? Constants.accentColor : Constants.accentColor),
      );

  Widget _line() {
    return Container(
      width: width * 7,
      color: Constants.whiteDisabled,
      height: width / 4,
    );
  }
}
