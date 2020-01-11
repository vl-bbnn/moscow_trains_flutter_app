import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/res/class.dart';
import 'package:trains/ui/res/time.dart';
import 'package:trains/ui/res/warningcard.dart';

class TrainCard extends StatelessWidget {
  final Train train;
  final bool first;

  const TrainCard({
    Key key,
    @required this.train,
    @required this.first,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final selected = Theme.of(context).textTheme.title;
    final regular = selected.copyWith(color: Constants.GREY);
    return Column(
      children: <Widget>[
        WarningCard(
          diff: train.timeDiff,
          first: first,
          last: false,
        ),
        SizedBox(
          height: Constants.PADDING_BIG,
        ),
        Container(
          height: Constants.TRAINCARD_HEIGHT,
          width: Constants.TRAINCARD_WIDTH,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: Constants.TRAINCARD_WIDTH / 2 - 48,
                    child: Time(
                      time: train.departure,
                      align: TextAlign.start,
                    ),
                  ),
                  Class(
                    type: train.type,
                    selected: true,
                  ),
                  Container(
                    width: Constants.TRAINCARD_WIDTH / 2 - 48,
                    child: Time(
                      time: train.arrival,
                      align: TextAlign.end,
                    ),
                  ),
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: Constants.TRAINCARD_WIDTH / 2 - 48,
                    child: Text(
                      train.from,
                      style: train.goingFromSelected ? selected : regular,
                      textAlign: TextAlign.start,
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_right,
                    size: 18,
                    color: Constants.GREY,
                  ),
                  Container(
                    width: Constants.TRAINCARD_WIDTH / 2 - 48,
                    child: Text(
                      train.to,
                      textAlign: TextAlign.end,
                      style: train.goingToSelected ? selected : regular,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(
          height: Constants.PADDING_BIG,
        ),
        train.isLast
            ? WarningCard(
                last: true,
                first: false,
                diff: 0,
              )
            : Container(),
      ],
    );
  }
}
