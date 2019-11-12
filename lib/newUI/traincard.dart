import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/newData/classes/train.dart';
import 'package:trains/newUI/indicator.dart';

class TrainCard extends StatelessWidget {
  final Train train;
  final bool selected;

  const TrainCard({Key key, @required this.train, @required this.selected})
      : super(key: key);

  Widget _rightColumn(BuildContext context) {
    final shortText = Helper.minutesToText(train.arrivalDiff)["shortText"];
    var color = Constants.GREY;
    var showDiff = false;
    if (!train.targetIsArrival) {
      if (train.arrivalDiff < 0) {
        color = Constants.POSITIVE_FOREGROUND;
        showDiff = true;
      }
    } else {
      showDiff = true;
      if (train.arrivalDiff > 0) color = Constants.POSITIVE_FOREGROUND;
      if (train.arrivalDiff <= -Constants.WARNINGAFTER)
        color = Constants.NEGATIVE_FOREGROUND;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showDiff
            ? Padding(
                padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                child: Text(
                  shortText,
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: color),
                ),
              )
            : Container(),
        _timeText(train.arrival),
      ],
    );
  }

  Widget _leftColumn(BuildContext context) {
    final shortText = Helper.minutesToText(train.departureDiff)["shortText"];
    var color = Constants.GREY;
    var showDiff = false;
    if (train.targetIsArrival) {
      if (train.departureDiff > 0) {
        color = Constants.POSITIVE_FOREGROUND;
        showDiff = true;
      }
    } else {
      showDiff = true;
      if (train.departureDiff < 0) color = Constants.POSITIVE_FOREGROUND;
      if (train.departureDiff >= Constants.WARNINGAFTER)
        color = Constants.NEGATIVE_FOREGROUND;
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        showDiff
            ? Padding(
                padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                child: Text(
                  shortText,
                  style: Theme.of(context)
                      .textTheme
                      .subhead
                      .copyWith(color: color),
                ),
              )
            : Container(),
        _timeText(train.departure),
      ],
    );
  }

  _timeText(DateTime time) {
    return Padding(
      padding: const EdgeInsets.all(Constants.PADDING_SMALL),
      child: RichText(
        text: TextSpan(children: [
          TextSpan(
            text: DateFormat("H").format(time),
            style: TextStyle(
                fontSize: 30,
                fontFamily: "LexendDeca",
                fontWeight: FontWeight.w500,
                color: Constants.WHITE),
          ),
          TextSpan(
            text: ":" + DateFormat("mm").format(time),
            style: TextStyle(
                fontSize: 24,
                fontFamily: "LexendDeca",
                fontWeight: FontWeight.w500,
                color: Constants.WHITE),
          )
        ]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: selected ? Constants.TRAINCARD_HEIGHT * 0.375 : 0),
      child: Container(
        height: Constants.TRAINCARD_HEIGHT,
        width: Constants.TRAINCARD_WIDTH,
        child: Material(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(28.5)),
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(Constants.PADDING_BIG),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(width: 84, child: _leftColumn(context)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.PADDING_MEDIUM),
                  child: Indicator(
                    train: train,
                    width: 8.0,
                    height: 80.0,
                  ),
                ),
                Container(width: 84, child: _rightColumn(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
