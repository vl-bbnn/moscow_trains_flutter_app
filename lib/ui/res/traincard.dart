import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/res/mycolors.dart';
import 'package:trains/ui/res/stationcard.dart';
import 'package:trains/ui/res/time.dart';
import 'package:trains/ui/res/trainclasslogo.dart';
import 'package:trains/ui/res/warning.dart';

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Warning(
            diff: train.timeDiffToPrevTrain,
            first: first,
            betweenTrains: true,
            last: false,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Warning(
                diff: train.timeDiffToTarget,
                first: first,
                betweenTrains: false,
                last: false,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Time(
                    time: train.departure,
                    align: TextAlign.start,
                  ),
                  TrainClassLogo(
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
                height: 20,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: StationCard(
                      selected: train.fromSelected,
                      size: StationCardSize.small,
                      station: train.from,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: MyColors.GREY,
                    ),
                  ),
                  Expanded(
                    child: StationCard(
                      selected: train.toSelected,
                      right: true,
                      size: StationCardSize.small,
                      station: train.to,
                    ),
                  ),
                ],
              ),
            ],
          ),
          train.isLast
              ? Warning(
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
