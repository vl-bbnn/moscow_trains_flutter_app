import 'package:flutter/material.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/mysizes.dart';

class SelectedRoad extends StatefulWidget {
  final Status status;
  final double value;
  final TrainClass trainClass;

  const SelectedRoad(
      {this.status: Status.notFound,
      this.value: 0.0,
      this.trainClass: TrainClass.standart});

  @override
  _SelectedRoadState createState() => _SelectedRoadState();
}

class _SelectedRoadState extends State<SelectedRoad> {
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
        return MyColors.LE_B70;
      case Status.notFound:
        return MyColors.WA_B70;
    }
  }

  foregroundColor() {
    switch (widget.trainClass) {
      case TrainClass.standart:
        return MyColors.ST_B70;
      case TrainClass.comfort:
        return MyColors.D3_B70;
      case TrainClass.express:
        return MyColors.EX_B70;
    }
  }

  _fullHeight() {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final departureFullHeight = padding.top +
        Helper.height(
            MainScreenSizes.TOP_PADDING + StationSizes.STATION_HEIGHT / 2,
            size);
    final arrivalFullHeight = padding.bottom +
        Helper.height(
            MainScreenSizes.BOTTOM_PADDING +
                NavPanelSizes.PANEL_HEIGHT +
                NavPanelSizes.BOTTOM_PADDING +
                StationSizes.STATION_HEIGHT / 2,
            size);
    return size.height - departureFullHeight - arrivalFullHeight;
  }

  @override
  Widget build(BuildContext context) {
    update();
    final height = fullHeight * widget.value;
    return Container(
      height: fullHeight,
      width: SchemeSizes.LINE_WIDTH,
      color: backColor,
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
