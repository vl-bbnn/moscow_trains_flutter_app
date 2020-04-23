import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/mysizes.dart';
import 'package:trains/ui/common/timetext.dart';
import 'package:trains/ui/schedulepage/stopstext.dart';
import 'package:trains/ui/schedulepage/trainclasstext.dart';

class TrainCard extends StatelessWidget {
  final train;
  final left;
  final right;
  final curvedValue;
  final selectedDepartureTime;

  const TrainCard(
      {this.train,
      this.left: false,
      this.right: true,
      this.curvedValue: 0.0,
      this.selectedDepartureTime});

  // _breakText(context, List<Train> list, int selectedIndex) {
  //   if (list.length > 1) {
  //     final selectedLast = selectedIndex == list.length - 1;
  //     final leftIndex = !selectedLast ? selectedIndex : selectedIndex - 1;
  //     final rightIndex = !selectedLast ? selectedIndex + 1 : selectedIndex;
  //     final minutes = Helper.timeDiffInMins(list.elementAt(leftIndex).departure,
  //         list.elementAt(rightIndex).departure);
  //     if (minutes == 0)
  //       return Text(
  //         "в то же\nвремя".toUpperCase(),
  //         style: Theme.of(context).textTheme.headline1,
  //       );
  //     final text = Helper.minutesToText(minutes);
  //     return TimeText(
  //       text: text,
  //       warn: minutes > 15,
  //       align: TextAlign.center,
  //     );
  //   } else {
  //     return Container();
  //   }
  // }

  _innerPadding(size) {
    final regularPadding = EdgeInsets.fromLTRB(
        Helper.width(
            left
                ? RegularTrainSizes.OTHER_PADDING
                : RegularTrainSizes.CENTER_PADDING,
            size),
        Helper.height(RegularTrainSizes.VERTICAL_PADDING, size),
        Helper.width(
            right
                ? RegularTrainSizes.OTHER_PADDING
                : RegularTrainSizes.CENTER_PADDING,
            size),
        Helper.height(RegularTrainSizes.VERTICAL_PADDING, size));
    final selectedPadding = EdgeInsets.symmetric(
      horizontal: Helper.width(SelectedTrainSizes.HORIZONTAL_PADDING, size),
      vertical: Helper.height(RegularTrainSizes.VERTICAL_PADDING, size),
    );
    final padding =
        EdgeInsets.lerp(regularPadding, selectedPadding, curvedValue);
    return padding;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final hasData = train != null;
    final stops = hasData
        ? train.price != null ? (curvedValue * train.price).round() : 0
        : null;
    final selectedMinutes = hasData
        ? (curvedValue * Helper.timeDiffInMins(train.departure, train.arrival))
            .round()
        : null;
    final regularMinutes = selectedDepartureTime != null
        ? ((1 - curvedValue) *
                Helper.timeDiffInMins(train.departure, selectedDepartureTime))
            .round()
        : 0;
    final cardHeight = Helper.height(
        RegularTrainSizes.CARD_HEIGHT +
            curvedValue *
                (SelectedTrainSizes.CARD_HEIGHT -
                    RegularTrainSizes.CARD_HEIGHT),
        size);
    final cardWidth = Helper.width(
        RegularTrainSizes.CARD_WIDTH +
            curvedValue *
                (SelectedTrainSizes.CARD_WIDTH - RegularTrainSizes.CARD_WIDTH),
        size);
    final stopsWidth =
        Helper.width(curvedValue * SelectedTrainSizes.STOPS_TEXT_WIDTH, size);
    final selectedTimeTextWidth =
        Helper.width(curvedValue * SelectedTrainSizes.TIME_TEXT_WIDTH, size);
    final regularTimeTextWidth =
        Helper.width(RegularTrainSizes.TEXT_WIDTH * (1 - curvedValue), size);
    final selectedTextHeight =
        Helper.height(curvedValue * SelectedTrainSizes.TEXT_HEIGHT, size);
    final regularTimeTextHeight =
        Helper.height(RegularTrainSizes.TEXT_HEIGHT * (1 - curvedValue), size);
    final color = Color.lerp(MyColors.BACK_SE, MyColors.BACK_EL, curvedValue)
        .withOpacity(0.7);
    final borderRadius = BorderRadius.circular(12 + curvedValue * (18 - 12));
    final innerPadding = _innerPadding(size);
    final outerPadding = EdgeInsets.symmetric(
        horizontal:
            Helper.width(curvedValue * RegularTrainSizes.OUTER_PADDING, size));
    final cardAlignment = Alignment.lerp(
        left ? Alignment.centerRight : Alignment.centerLeft,
        Alignment.center,
        curvedValue);
    final selectedCardContentPadding =
        Helper.height(curvedValue * SelectedTrainSizes.CONTENT_PADDING, size);
    final regularCardContentPadding = Helper.height(
        RegularTrainSizes.CONTENT_PADDING * (1 - curvedValue), size);
    return Align(
      alignment: cardAlignment,
      child: Padding(
        padding: outerPadding,
        child: ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            filter: ImageFilter.blur(
                sigmaX: 6.0 * (1 + curvedValue),
                sigmaY: 6.0 * (1 + curvedValue)),
            child: Container(
              height: cardHeight,
              width: cardWidth,
              color: color,
              padding: innerPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TrainClassText(train: train, curvedValue: curvedValue),
                  SizedBox(
                    height: selectedCardContentPadding,
                  ),
                  Opacity(
                    opacity: curvedValue,
                    child: StopsText(
                        stops: stops,
                        width: stopsWidth,
                        height: selectedTextHeight),
                  ),
                  SizedBox(
                    height: selectedCardContentPadding,
                  ),
                  Opacity(
                    opacity: curvedValue,
                    child: TimeText(
                      time: selectedMinutes,
                      width: selectedTimeTextWidth,
                      height: selectedTextHeight,
                      animated: true,
                    ),
                  ),
                  SizedBox(
                    height: regularCardContentPadding,
                  ),
                  Opacity(
                    opacity: 1 - curvedValue,
                    child: TimeText(
                      textAlign: TextAlign.center,
                      align: Alignment.center,
                      time: regularMinutes,
                      width: regularTimeTextWidth,
                      height: regularTimeTextHeight,
                      short: true,
                      animated: true,
                      shouldWarn: regularMinutes > 15,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
