import 'package:flutter/material.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/common/mycolors.dart';

class TrainPath extends StatelessWidget {
  final Status status;
  final Sizes sizes;
  final double trainValue;
  final TrainClass trainClass;
  final QueryType type;

  const TrainPath({
    this.status,
    this.sizes,
    this.trainValue,
    this.trainClass,
    this.type,
  });

  _backgroundColor() {
    switch (status) {
      case Status.searching:
      case Status.found:
        return MyColors.LE_B70;
      case Status.notFound:
        return MyColors.WA_B70;
    }
  }

  _foregroundColor() {
    switch (trainClass) {
      case TrainClass.standart:
        return MyColors.ST_B70;
      case TrainClass.comfort:
        return MyColors.D3_B70;
      case TrainClass.express:
        return MyColors.EX_B70;
    }
  }

  _align() {
    switch (type) {
      case QueryType.departure:
        return Alignment.bottomCenter;
      case QueryType.arrival:
        return Alignment.topCenter;
    }
  }

  _borderRadius(double lineWidth) {
    final radius = Radius.circular(lineWidth / 2 - lineWidth / 4 * trainValue);
    switch (type) {
      case QueryType.departure:
        return BorderRadius.only(topLeft: radius, topRight: radius);
      case QueryType.arrival:
        return BorderRadius.only(bottomLeft: radius, bottomRight: radius);
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedFullHeight = sizes.scheme.trainRoadHeight / 2;
    final backColor = _backgroundColor();
    final foreColor = _foregroundColor();
    final height = selectedFullHeight * trainValue;
    final width = sizes.scheme.lineWidth;
    final borderRadius = _borderRadius(width);

    return Container(
      height: selectedFullHeight,
      width: width,
      color: backColor,
      child: status == Status.found
          ? Align(
              alignment: _align(),
              child: Container(
                height: height,
                decoration: ShapeDecoration(
                    color: foreColor,
                    shape: RoundedRectangleBorder(borderRadius: borderRadius)),
              ),
            )
          : SizedBox(),
    );
  }
}
