import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/res/class.dart';
import 'package:trains/ui/res/stationcard.dart';
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
    return Opacity(
      opacity: train.departure
              .isBefore(DateTime.now().subtract(Duration(minutes: 1)))
          ? 0.6
          : 1,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          WarningCard(
            diff: train.timeDiffToPrevTrain,
            first: first,
            betweenTrains: true,
            last: false,
          ),
          Material(
            color: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
                side: BorderSide(color: Constants.ELEVATED_2, width: 3)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  WarningCard(
                    diff: train.timeDiffToTarget,
                    first: first,
                    betweenTrains: false,
                    last: false,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Time(
                        time: train.departure,
                        align: TextAlign.start,
                      ),
                      Class(
                        type: train.trainClass,
                        selected: true,
                      ),
                      Time(
                        time: train.arrival,
                        align: TextAlign.end,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      StationCard(
                        selected: train.fromSelected,
                        right: false,
                        small: true,
                        station: train.from,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        size: 14,
                        color: Constants.GREY,
                      ),
                      StationCard(
                        selected: train.toSelected,
                        right: true,
                        small: true,
                        station: train.to,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          train.isLast
              ? WarningCard(
                  last: true,
                  first: false,
                  betweenTrains: false,
                  diff: 0,
                )
              : Container(),
        ],
      ),
    );
  }
}
