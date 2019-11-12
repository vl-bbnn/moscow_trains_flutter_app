import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/newData/blocs/inheritedbloc.dart';
import 'package:trains/newData/blocs/navbloc.dart';
import 'package:trains/newData/classes/train.dart';
import 'package:trains/newUI/squirclebutton.dart';
import 'package:trains/newUI/traincard.dart';

class BigTrainCard extends StatelessWidget {
  final Train train;

  Widget _trainTitle(BuildContext context) {
    final navBloc = InheritedBloc.navOf(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 85,
              child: Padding(
                padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                child: Text(
                  Helper.trainTypeName(train.type),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ),
            Container(
              width: 85,
              child: Padding(
                padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                child: Text(
                  Helper.minutesToText(Helper.timeDiffInMins(
                      train.arrival, train.departure))['shortText'],
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ),
          ],
        ),
        Container(
          height: 8,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                    child: Text(
                      train.from + " -",
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: Constants.WHITE),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                    child: Text(
                      train.to,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: Constants.WHITE),
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              child: Icon(
                Icons.arrow_forward,
                color: Constants.GREY,
              ),
              onTap: () => navBloc.state.add(NavState.Train),
            )
          ],
        ),
      ],
    );
  }

  const BigTrainCard({Key key, this.train}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.PADDING_BIG),
      child: Container(
        height: Constants.TRAINCARD_HEIGHT * 1.75,
        width: Constants.TRAINCARD_WIDTH,
        child: Material(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(35),
              side: BorderSide(color: Constants.PRIMARY, width: 3)),
          color: Constants.BACKGROUND,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TrainCard(train: train, selected: false),
              Padding(
                padding: const EdgeInsets.fromLTRB(Constants.PADDING_BIG, 0,
                    Constants.PADDING_BIG, Constants.PADDING_BIG),
                child: _trainTitle(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
