import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';

class StationIcon extends StatelessWidget {
  final TrainClass trainClass;
  final double iconValue;
  final bool selected;
  final Station station;
  final Status status;
  final QueryType type;
  final Sizes sizes;

  const StationIcon(
      {this.type,
      this.status,
      this.sizes,
      this.iconValue,
      this.selected,
      this.station,
      this.trainClass});

  _backgroundColor() {
    switch (status) {
      case Status.searching:
      case Status.found:
        return MyColors.LE;
      case Status.notFound:
        return MyColors.WA;
    }
  }

  _foregroundColor() {
    switch (trainClass) {
      case TrainClass.standart:
        return MyColors.ST;
      case TrainClass.comfort:
        return MyColors.D3;
      case TrainClass.express:
        return MyColors.EX;
    }
  }

  @override
  Widget build(BuildContext context) {
    final backColor = _backgroundColor();
    final foreColor = _foregroundColor();

    final lineWidth = sizes.scheme.lineWidth;

    final onTop = type == QueryType.departure;
    final stopRadius = BorderRadius.only(
        topLeft: Radius.circular(onTop ? lineWidth / 2 : 0),
        bottomLeft: Radius.circular(onTop ? 0 : lineWidth / 2),
        topRight: Radius.circular(2),
        bottomRight: Radius.circular(2));
    final terminalRadius = BorderRadius.circular(2);

    final stopPadding =
        EdgeInsets.fromLTRB(lineWidth / 2, lineWidth / 2, 0, lineWidth / 2);
    final terminalPadding =
        EdgeInsets.fromLTRB(0, lineWidth / 2, lineWidth / 2, lineWidth / 2);

    final roadTerminal = station.terminal;
    final hasTransit = station.transitList.isNotEmpty;
    final zeroRadius = roadTerminal ? terminalRadius : stopRadius;
    final zeroPadding = roadTerminal ? terminalPadding : stopPadding;

    final finalRadius = selected ? terminalRadius : stopRadius;
    final finalPadding = selected ? terminalPadding : stopPadding;

    final radius = BorderRadius.lerp(zeroRadius, finalRadius, iconValue);
    final padding = EdgeInsets.lerp(zeroPadding, finalPadding, iconValue);
    final color = Color.lerp(backColor, foreColor, iconValue);

    if (hasTransit)
      return Padding(
        padding: EdgeInsets.only(right: lineWidth / 2),
        child: Container(
          decoration: ShapeDecoration(shape: CircleBorder(), color: color),
          width: lineWidth * 2,
          height: lineWidth * 2,
          child: Center(
            child: Container(
              width: lineWidth,
              height: lineWidth,
              decoration: ShapeDecoration(
                  shape: CircleBorder(), color: MyColors.BACK_PR),
            ),
          ),
        ),
      );

    return Padding(
      padding: padding,
      child: Container(
        width: lineWidth * 2,
        height: lineWidth,
        decoration: ShapeDecoration(
            color: color, shape: RoundedRectangleBorder(borderRadius: radius)),
      ),
    );
  }
}
