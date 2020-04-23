import 'package:flutter/material.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/mysizes.dart';

class StationIcon extends StatefulWidget {
  final Status status;
  final bool hasTransit;
  final bool roadTerminal;
  final bool trainTerminal;
  final TrainClass trainClass;
  final double value;
  final QueryType type;

  const StationIcon(
      {this.hasTransit: false,
      this.roadTerminal: true,
      this.value: 0.0,
      this.type: QueryType.departure,
      this.trainClass: TrainClass.standart,
      this.trainTerminal: true,
      this.status: Status.notFound});

  @override
  _StationIconState createState() => _StationIconState();
}

class _StationIconState extends State<StationIcon> {
  double fullHeight;
  double radius;
  EdgeInsets zeroPadding;
  EdgeInsets fullPadding;
  BorderRadius zeroRadius;
  BorderRadius fullRadius;
  Alignment align;
  Color backColor;
  Color foreColor;

  update() {
    radius = SchemeSizes.LINE_WIDTH;

    final onTop = widget.type == QueryType.departure;
    final stopPadding =
        EdgeInsets.fromLTRB(radius / 2, radius / 2, 0, radius / 2);
    final terminalPadding =
        EdgeInsets.fromLTRB(0, radius / 2, radius / 2, radius / 2);
    final stopRadius = BorderRadius.only(
        topLeft: Radius.circular(onTop ? radius / 2 : 0),
        bottomLeft: Radius.circular(onTop ? 0 : radius / 2),
        topRight: Radius.circular(2),
        bottomRight: Radius.circular(2));
    final terminalRadius = BorderRadius.circular(2);

    zeroPadding = widget.roadTerminal ? terminalPadding : stopPadding;
    fullPadding = widget.trainTerminal ? terminalPadding : stopPadding;

    zeroRadius = widget.roadTerminal ? terminalRadius : stopRadius;
    fullRadius = widget.trainTerminal ? terminalRadius : stopRadius;

    backColor = backgroundColor();
    foreColor = foregroundColor();
  }

  backgroundColor() {
    switch (widget.status) {
      case Status.searching:
      case Status.found:
        return MyColors.LE;
      case Status.notFound:
        return MyColors.WA;
    }
  }

  foregroundColor() {
    switch (widget.trainClass) {
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
    update();
    final found = widget.status == Status.found;
    final color =
        found ? Color.lerp(backColor, foreColor, widget.value) : backColor;

    if (widget.hasTransit)
      return Padding(
        padding: EdgeInsets.only(right: radius / 2),
        child: Container(
          decoration: ShapeDecoration(shape: CircleBorder(), color: color),
          width: radius * 2,
          height: radius * 2,
          child: Center(
            child: Container(
              width: radius,
              height: radius,
              decoration: ShapeDecoration(
                  shape: CircleBorder(), color: MyColors.BACK_PR),
            ),
          ),
        ),
      );

    final padding = found
        ? EdgeInsets.lerp(zeroPadding, fullPadding, widget.value)
        : zeroPadding;

    final borderRadius = found
        ? BorderRadius.lerp(zeroRadius, fullRadius, widget.value)
        : zeroRadius;

    return Padding(
      padding: padding,
      child: Container(
        width: radius * 2,
        height: radius,
        decoration: ShapeDecoration(
            color: color,
            shape: RoundedRectangleBorder(borderRadius: borderRadius)),
      ),
    );
  }
}
