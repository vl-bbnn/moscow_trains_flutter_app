import 'package:flutter/material.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';

class RoadPath extends StatelessWidget {
  final Status status;
  final Sizes sizes;
  final QueryType type;
  final double roadValue;
  final TrainClass trainClass;
  final bool selected;
  final bool terminal;

  const RoadPath(
      {this.status,
      this.type,
      this.sizes,
      this.roadValue,
      this.trainClass,
      this.selected,
      this.terminal});

  _backgroundColor() {
    switch (status) {
      case Status.searching:
      case Status.found:
        return MyColors.LE_B40;
      case Status.notFound:
        return MyColors.WA_B40;
    }
  }

  _foregroundColor() {
    switch (trainClass) {
      case TrainClass.standart:
        return MyColors.ST_B40;
      case TrainClass.comfort:
        return MyColors.D3_B40;
      case TrainClass.express:
        return MyColors.EX_B40;
    }
  }

  _fullHeight() {
    switch (type) {
      case QueryType.departure:
        return sizes.scheme.departureRoadHeight;
      case QueryType.arrival:
        return sizes.scheme.arrivalRoadHeight;
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

  @override
  Widget build(BuildContext context) {
    final fullHeight = _fullHeight();
    final backColor = _backgroundColor();
    final foreColor = _foregroundColor();

    return Container(
      height: fullHeight,
      width: sizes.scheme.lineWidth,
      color: !terminal ? backColor : null,
      child: status == Status.found && !selected && !terminal
          ? Align(
              alignment: _align(),
              child: Container(
                height: fullHeight * roadValue,
                color: foreColor,
              ),
            )
          : SizedBox(),
    );
  }
}
