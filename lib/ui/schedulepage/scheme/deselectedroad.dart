import 'package:flutter/material.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/mysizes.dart';

class DeselectedRoad extends StatefulWidget {
  final Status status;
  final double value;
  final QueryType type;
  final TrainClass trainClass;
  final bool roadTerminal;

  const DeselectedRoad(
      {this.status: Status.notFound,
      this.value: 0.0,
      this.roadTerminal: false,
      this.type: QueryType.departure,
      this.trainClass: TrainClass.standart});

  @override
  _DeselectedRoadState createState() => _DeselectedRoadState();
}

class _DeselectedRoadState extends State<DeselectedRoad> {
  double fullHeight;
  Color backColor;
  Color foreColor;

  update() {
    backColor = backgroundColor();
    foreColor = foregroundColor();
    fullHeight = _fullHeight();
  }

  backgroundColor() {
    switch (widget.status) {
      case Status.searching:
      case Status.found:
        return MyColors.LE_B40;
      case Status.notFound:
        return MyColors.WA_B40;
    }
  }

  foregroundColor() {
    switch (widget.trainClass) {
      case TrainClass.standart:
        return MyColors.ST_B40;
      case TrainClass.comfort:
        return MyColors.D3_B40;
      case TrainClass.express:
        return MyColors.EX_B40;
    }
  }

  _fullHeight() {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    switch (widget.type) {
      case QueryType.departure:
        return padding.top +
            Helper.height(
                MainScreenSizes.TOP_PADDING + StationSizes.STATION_HEIGHT / 2,
                MediaQuery.of(context).size);
      case QueryType.arrival:
        return padding.bottom +
            Helper.height(
                MainScreenSizes.BOTTOM_PADDING +
                    NavPanelSizes.PANEL_HEIGHT +
                    NavPanelSizes.BOTTOM_PADDING +
                    StationSizes.STATION_HEIGHT / 2,
                size);
    }
  }

  @override
  Widget build(BuildContext context) {
    update();
    final height = fullHeight * widget.value;
    return Container(
      height: fullHeight,
      width: SchemeSizes.LINE_WIDTH,
      color: widget.roadTerminal ? null : backColor,
      child: widget.status == Status.found
          ? Align(
              alignment: Alignment.topCenter,
              child: Container(
                height: height,
                color: foreColor,
                // decoration: ShapeDecoration(
                //     shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.lerp())),
              ),
            )
          : SizedBox(),
    );
  }
}
