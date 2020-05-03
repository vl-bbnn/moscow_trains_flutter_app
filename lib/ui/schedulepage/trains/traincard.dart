import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/timetext.dart';
import 'package:trains/ui/schedulepage/stopstext.dart';
import 'package:trains/ui/schedulepage/trains/trainclasstext.dart';
import 'package:trains/ui/schedulepage/trains/traindot.dart';

class TrainCard extends StatelessWidget {
  final train;
  final left;
  final right;
  final curvedValue;
  final selectedDepartureTime;

  final Sizes sizes;

  const TrainCard(
      {this.train,
      this.left: false,
      this.right: true,
      this.curvedValue: 0.0,
      this.selectedDepartureTime,
      this.sizes});

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

  @override
  Widget build(BuildContext context) {
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

    final cardHeight = sizes.regularTrainCardHeight +
        curvedValue *
            (sizes.selectedTrainCardHeight - sizes.regularTrainCardHeight);
    final cardWidth = sizes.regularTrainCardWidth +
        curvedValue *
            (sizes.selectedTrainCardWidth - sizes.regularTrainCardWidth);

    final stopsWidth = sizes.selectedTrainStopsTextWidth * curvedValue;
    final selectedTimeTextWidth =
        sizes.selectedTrainTimeTextWidth * curvedValue;
    final regularTimeTextWidth =
        sizes.regularTrainTextWidth * (1 - curvedValue);
    final selectedTextHeight = sizes.selectedTrainTextHeight * curvedValue;
    final regularTimeTextHeight =
        sizes.regularTrainTextHeight * (1 - curvedValue);

    final color = Color.lerp(MyColors.BACK_SE, MyColors.BACK_EL, curvedValue)
        .withOpacity(0.7);
    final borderRadius = BorderRadius.circular(12 + curvedValue * (18 - 12));

    final regularPadding = EdgeInsets.symmetric(
        horizontal: sizes.regularTrainHorizontalPadding,
        vertical: sizes.regularTrainVerticalPadding);

    final selectedPadding = EdgeInsets.symmetric(
        horizontal: sizes.selectedTrainHorizontalPadding,
        vertical: sizes.selectedTrainVerticalPadding);

    final innerPadding =
        EdgeInsets.lerp(regularPadding, selectedPadding, curvedValue);
    final outerPadding = EdgeInsets.symmetric(
        horizontal: sizes.regularTrainOuterPadding * (1 - curvedValue));

    final cardAlignment = Alignment.lerp(
        left ? Alignment.centerRight : Alignment.centerLeft,
        Alignment.center,
        curvedValue);

    final selectedCardContentPadding =
        sizes.selectedTrainContentPadding * curvedValue;
    final regularCardContentPadding =
        sizes.regularTrainContentPadding * (1 - curvedValue);

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
              child: Row(
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      TrainDot(
                        curvedValue: curvedValue,
                        train: train,
                        sizes: sizes,
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
                  SizedBox(
                    width: selectedCardContentPadding,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        TrainClassText(
                            train: train,
                            curvedValue: curvedValue,
                            sizes: sizes),
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
                      ],
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
