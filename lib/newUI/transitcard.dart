import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/my_icons_icons.dart';
import 'package:trains/newData/classes/transit.dart';
import 'dart:math';

class TransitCard extends StatelessWidget {
  final Transit transit;

  Color _metroColor(int line) {
    switch (line) {
      case 1:
        return Constants.METRO1;
      case 5:
        return Constants.METRO5;
      case 9:
        return Constants.METRO9;
      case 10:
        return Constants.METRO10;
      case 14:
        return Constants.METRO14;
      default:
        return Constants.BLACK;
    }
  }

  Widget _times(BuildContext context) {
    final text = transit.times.length > 1
        ? transit.times.reduce(min).toString() +
            " - " +
            transit.times.reduce(max).toString() +
            " мин"
        : transit.times.first.toString() + " мин";
    return Text(
      text,
      style: Theme.of(context).textTheme.subhead,
    );
  }

  const TransitCard({Key key, this.transit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 235,
      child: Row(
        children: <Widget>[
          Row(
            children: <Widget>[
              Row(
                children: transit.lines
                    .map((line) =>
                        Icon(MyIcons.metro, size: 24, color: _metroColor(line)))
                    .toList(),
              ),
              transit.accessible
                  ? Padding(
                      padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                      child: Icon(
                        Icons.accessible,
                        size: 18,
                        color: Constants.ACCESSIBLE,
                      ),
                    )
                  : Container(),
            ],
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.all(Constants.PADDING_REGULAR),
                child: _times(context)),
          ),
        ],
      ),
    );
  }
}
