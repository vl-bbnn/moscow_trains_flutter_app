import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/ui/common/mysizes.dart';

class RegularTrainCardSizes {
  double outerPadding;

  double cardHeight;
  double cardWidth;

  double verticalPadding;
  double horizontalPadding;

  double textHeight;
  double textWidth;

  double iconWidth;
  double iconHeight;

  double iconTextPadding;

  RegularTrainCardSizes.fromData(
      MediaQueryData data, height(double value), width(double value)) {
    outerPadding = width(RegularTrainSizes.OUTER_PADDING);

    cardHeight = height(RegularTrainSizes.CARD_HEIGHT);
    cardWidth = width(RegularTrainSizes.CARD_WIDTH);

    verticalPadding = height(RegularTrainSizes.VERTICAL_PADDING);
    horizontalPadding = width(RegularTrainSizes.HORIZONTAL_PADDING);

    textHeight = height(RegularTrainSizes.TEXT_HEIGHT);
    textWidth = width(RegularTrainSizes.TEXT_WIDTH);

    iconHeight = height(RegularTrainSizes.ICON_HEIGHT);
    iconWidth = width(RegularTrainSizes.ICON_WIDTH);

    iconTextPadding = height(RegularTrainSizes.ICON_TEXT_PADDING);
  }
}

class SelectedTrainCardSizes {
  double outerPadding;

  double cardHeight;
  double cardWidth;

  double verticalPadding;
  double horizontalPadding;

  double textHeight;
  double textWidth;
  double priceTextWidth;
  double stopsTextWidth;
  double timeTextWidth;

  double textPadding;

  double iconWidth;
  double iconHeight;

  double iconTextPadding;

  SelectedTrainCardSizes.fromData(
      MediaQueryData data, height(double value), width(double value)) {
    outerPadding = width(SelectedTrainSizes.OUTER_PADDING);

    cardHeight = height(SelectedTrainSizes.CARD_HEIGHT);
    cardWidth = width(SelectedTrainSizes.CARD_WIDTH);

    verticalPadding = height(SelectedTrainSizes.VERTICAL_PADDING);
    horizontalPadding = width(SelectedTrainSizes.HORIZONTAL_PADDING);

    textHeight = height(SelectedTrainSizes.TEXT_HEIGHT);
    textWidth = width(SelectedTrainSizes.TEXT_WIDTH);

    textPadding = height(SelectedTrainSizes.TEXT_PADDING);

    iconHeight = height(SelectedTrainSizes.ICON_HEIGHT);
    iconWidth = width(SelectedTrainSizes.ICON_WIDTH);

    iconTextPadding = width(SelectedTrainSizes.ICON_TEXT_PADDING);
  }
}

class Sizes {
  RegularTrainCardSizes regularTrain;
  SelectedTrainCardSizes selectedTrain;

  double fullHeight;
  double fullWidth;
  double topPadding;
  double bottomPadding;

  //Scheme Sizes

  double schemeDepartureHeight;
  double schemeleArrivalHeight;
  double schemeIconSize;
  double schemeSelectedHeight;

  double schemeDeparturePercent;
  double schemeArrivalPercent;
  double schemeSelectedPercent;
  double schemeIconPercent;

  double schemeLeftPadding;
  double schemeWidth;

  double schemeTextHeight;
  double schemeTextWidth;
  double schemeTextVerticalPadding;

  double schemeLineWidth;
  double schemeLineLeftPadding;
  double schemeLineRightPadding;

  //Station Sizes

  double stationHeight;
  double stationTextHeight;
  double stationTextWidth;
  double stationRoundIconSize;
  double stationRectIconHeight;
  double stationRectIconWidth;
  double stationIconTextHeight;
  double stationIconTextWidth;
  double stationIconTextPadding;
  double stationTextPadding;

  //Time Sizes

  double timeHeight;
  double timeLabelTextWidth;
  double timeTextWidth;
  double timeLeftTextWidth;

  //Schedule Sizes

  double scheduleLeftPadding;
  double scheduleTopPadding;
  double scheduleRightPadding;
  double scheduleBottomPadding;

  double scheduleSpace;
  double scheduleSelectorTopOffset;
  double scheduleSelectorBottomOffset;

  //Nav Panel Sizes

  double navPanelHeight;
  double navPanelIconSize;
  double navPanelInnerHorizontalPadding;
  double navPanelInnerBottomPadding;
  double navPanelInnerTopPadding;
  double navPanelOuterHorizontalPadding;
  double navPanelOuterBottomadding;

  Sizes.fromMediaQueryData(MediaQueryData data) {
    final contextSize = data.size;

    final width =
        (double value) => contextSize.width * (value / CommonSizes.WIDTH);
    final height =
        (double value) => contextSize.height * (value / CommonSizes.HEIGHT);
    final size = (double value) {
      if (contextSize.width < contextSize.height)
        return contextSize.width * (value / CommonSizes.WIDTH);
      else
        return contextSize.height * (value / CommonSizes.HEIGHT);
    };

    final contextPadding = data.padding;

    fullHeight = height(CommonSizes.HEIGHT);
    fullWidth = width(CommonSizes.WIDTH);
    topPadding = contextPadding.top;
    bottomPadding = height(
            NavPanelSizes.OUTER_BOTTOM_PADDING + NavPanelSizes.PANEL_HEIGHT) +
        contextPadding.bottom;

    regularTrain = RegularTrainCardSizes.fromData(data, height, width);
    selectedTrain = SelectedTrainCardSizes.fromData(data, height, width);

    //Scheme Sizes

    schemeDepartureHeight = contextPadding.top +
        height(MainScreenSizes.TOP_PADDING + StationSizes.STATION_HEIGHT / 2);
    schemeleArrivalHeight = contextPadding.bottom +
        height(MainScreenSizes.BOTTOM_PADDING +
            NavPanelSizes.PANEL_HEIGHT +
            NavPanelSizes.BOTTOM_PADDING +
            StationSizes.STATION_HEIGHT / 2);
    schemeIconSize = size(SchemeSizes.LINE_WIDTH * 2);
    schemeSelectedHeight =
        fullHeight - schemeDepartureHeight - schemeleArrivalHeight;

    schemeDeparturePercent = schemeDepartureHeight / fullHeight;
    schemeArrivalPercent = schemeleArrivalHeight / fullHeight;
    schemeSelectedPercent = schemeSelectedHeight / fullHeight;
    schemeIconPercent = schemeIconSize / fullHeight;

    schemeLeftPadding = width(SchemeSizes.LEFT_PADDING);
    schemeWidth = width(SchemeSizes.SCHEME_WIDTH);

    //rotated by 90 degreees
    schemeTextWidth = width(SchemeSizes.TEXT_HEIGHT);
    schemeTextHeight = height(SchemeSizes.TEXT_WIDTH);
    schemeTextVerticalPadding = height(SchemeSizes.TEXT_VERTICAL_PADDING);

    schemeLineWidth = width(SchemeSizes.LINE_WIDTH);
    schemeLineLeftPadding = width(SchemeSizes.LINE_LEFT_PADDING);
    schemeLineRightPadding = width(SchemeSizes.LINE_RIGHT_PADDING);

    //Station Sizes

    stationHeight = height(StationSizes.STATION_HEIGHT);

    stationTextHeight = height(StationSizes.TEXT_HEIGHT);
    stationTextWidth = width(StationSizes.TEXT_WIDTH);

    stationRoundIconSize = size(StationSizes.ROUND_ICON_WIDTH);
    stationRectIconHeight = height(StationSizes.WIDE_ICON_HEIGHT);
    stationRectIconWidth = width(StationSizes.WIDE_ICON_WIDTH);

    stationIconTextHeight = height(StationSizes.ICON_TEXT_HEIGHT);
    stationIconTextWidth = width(StationSizes.ICON_TEXT_WIDTH);

    stationIconTextPadding = width(StationSizes.SMALL_PADDING);
    stationTextPadding = height(StationSizes.BIG_PADDING);

    //Time Sizes

    timeHeight = height(TimeSizes.TIME_HEIGHT);
    timeLabelTextWidth = width(TimeSizes.LABEL_TEXT_WIDTH);
    timeTextWidth = width(TimeSizes.TIME_TEXT_WIDTH);
    timeLeftTextWidth = width(TimeSizes.TIME_LEFT_TEXT_WIDTH);

    //Schedule Sizes

    scheduleLeftPadding = width(MainScreenSizes.LEFT_PADDING);
    scheduleTopPadding =
        contextPadding.top + height(MainScreenSizes.TOP_PADDING);
    scheduleRightPadding =
        contextPadding.right + width(MainScreenSizes.RIGHT_PADDING);
    scheduleBottomPadding = contextPadding.bottom +
        height(NavPanelSizes.PANEL_HEIGHT + MainScreenSizes.BOTTOM_PADDING);

    scheduleSpace = (fullHeight -
            scheduleTopPadding -
            scheduleBottomPadding -
            2 * stationHeight -
            2 * timeHeight -
            selectedTrain.cardHeight) /
        4;
    scheduleSelectorTopOffset = scheduleTopPadding +
        stationHeight +
        scheduleSpace +
        timeHeight +
        scheduleSpace;
    scheduleSelectorBottomOffset = scheduleBottomPadding +
        stationHeight +
        scheduleSpace +
        timeHeight +
        scheduleSpace;

    //Nav Panel Sizes

    navPanelHeight = height(NavPanelSizes.PANEL_HEIGHT);
    navPanelIconSize = size(NavPanelSizes.ICON_SIZE);
    navPanelInnerHorizontalPadding = width(NavPanelSizes.HORIZONTAL_PADDING);
    navPanelInnerBottomPadding = height(NavPanelSizes.BOTTOM_PADDING);
    navPanelInnerTopPadding = height(NavPanelSizes.TOP_PADDING);
    navPanelOuterHorizontalPadding =
        width(NavPanelSizes.OUTER_HORIZONTAL_PADDING);
    navPanelOuterBottomadding = width(NavPanelSizes.OUTER_BOTTOM_PADDING);
  }
}

class SizesBloc {
  final contextInputStream = BehaviorSubject<MediaQueryData>();

  final outputSizes = BehaviorSubject<Sizes>();

  SizesBloc() {
    contextInputStream.listen((data) {
      final newSizes = Sizes.fromMediaQueryData(data);

      outputSizes.add(newSizes);
    });
  }

  close() {
    contextInputStream.close();
    outputSizes.close();
  }
}
