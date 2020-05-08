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
      {MediaQueryData data, height(double value), width(double value)}) {
    outerPadding = width(RegularTrainConstants.OUTER_PADDING);

    cardHeight = height(RegularTrainConstants.CARD_HEIGHT);
    cardWidth = width(RegularTrainConstants.CARD_WIDTH);

    verticalPadding = height(RegularTrainConstants.VERTICAL_PADDING);
    horizontalPadding = width(RegularTrainConstants.HORIZONTAL_PADDING);

    textHeight = height(RegularTrainConstants.TEXT_HEIGHT);
    textWidth = width(RegularTrainConstants.TEXT_WIDTH);

    iconHeight = height(RegularTrainConstants.ICON_HEIGHT);
    iconWidth = width(RegularTrainConstants.ICON_WIDTH);

    iconTextPadding = height(RegularTrainConstants.ICON_TEXT_PADDING);
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
      {MediaQueryData data, height(double value), width(double value)}) {
    outerPadding = width(SelectedTrainConstants.OUTER_PADDING);

    cardHeight = height(SelectedTrainConstants.CARD_HEIGHT);
    cardWidth = width(SelectedTrainConstants.CARD_WIDTH);

    verticalPadding = height(SelectedTrainConstants.VERTICAL_PADDING);
    horizontalPadding = width(SelectedTrainConstants.HORIZONTAL_PADDING);

    textHeight = height(SelectedTrainConstants.TEXT_HEIGHT);
    textWidth = width(SelectedTrainConstants.TEXT_WIDTH);

    textPadding = height(SelectedTrainConstants.TEXT_PADDING);

    iconHeight = height(SelectedTrainConstants.ICON_HEIGHT);
    iconWidth = width(SelectedTrainConstants.ICON_WIDTH);

    iconTextPadding = width(SelectedTrainConstants.ICON_TEXT_PADDING);
  }
}

class SchemeSizes {
  double totalWidth;
  double leftPadding;

  double departureRoadHeight;
  double arrivalRoadHeight;
  double trainRoadHeight;
  double iconSize;

  double roadPercent;
  double trainPercent;
  double iconPercent;

  double textWidth;
  double textHeight;
  double textVerticalPadding;
  double textPadding;

  double lineWidth;
  double lineLeftPadding;
  double lineRightPadding;

  SchemeSizes.fromData(
      {MediaQueryData data,
      EdgeInsets contextPadding,
      double fullHeight,
      height(double value),
      width(double value),
      size(double value)}) {
    departureRoadHeight = contextPadding.top +
        height(MainScreenConstants.TOP_PADDING +
            StationConstants.STATION_HEIGHT / 2);

    arrivalRoadHeight = contextPadding.bottom +
        height(MainScreenConstants.BOTTOM_PADDING +
            NavPanelConstants.PANEL_HEIGHT +
            NavPanelConstants.BOTTOM_PADDING +
            StationConstants.STATION_HEIGHT / 2);
    iconSize = size(SchemeConstants.LINE_WIDTH * 2);

    trainRoadHeight = fullHeight - departureRoadHeight - arrivalRoadHeight;

    roadPercent = (departureRoadHeight + arrivalRoadHeight) / (fullHeight * 2);
    trainPercent = trainRoadHeight / fullHeight;
    iconPercent = iconSize / fullHeight;

    leftPadding = width(SchemeConstants.LEFT_PADDING);
    totalWidth = width(SchemeConstants.SCHEME_WIDTH);

    //rotated by 90 degreees
    textWidth = width(SchemeConstants.TEXT_HEIGHT);
    textHeight = height(SchemeConstants.TEXT_WIDTH);
    textVerticalPadding = height(SchemeConstants.TEXT_VERTICAL_PADDING);

    lineWidth = width(SchemeConstants.LINE_WIDTH);
    lineLeftPadding = width(SchemeConstants.LINE_LEFT_PADDING);
    lineRightPadding = width(SchemeConstants.LINE_RIGHT_PADDING);
  }
}

class Sizes {
  RegularTrainCardSizes regularTrain;
  SelectedTrainCardSizes selectedTrain;
  SchemeSizes scheme;

  double fullHeight;
  double fullWidth;
  double topPadding;
  double bottomPadding;

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
        (double value) => contextSize.width * (value / CommonConstants.WIDTH);
    final height =
        (double value) => contextSize.height * (value / CommonConstants.HEIGHT);
    final size = (double value) {
      if (contextSize.width < contextSize.height)
        return contextSize.width * (value / CommonConstants.WIDTH);
      else
        return contextSize.height * (value / CommonConstants.HEIGHT);
    };

    final contextPadding = data.padding;

    fullHeight = height(CommonConstants.HEIGHT);
    fullWidth = width(CommonConstants.WIDTH);
    topPadding = contextPadding.top;
    bottomPadding = height(NavPanelConstants.OUTER_BOTTOM_PADDING +
            NavPanelConstants.PANEL_HEIGHT) +
        contextPadding.bottom;

    regularTrain = RegularTrainCardSizes.fromData(
        data: data, height: height, width: width);
    selectedTrain = SelectedTrainCardSizes.fromData(
        data: data, height: height, width: width);
    scheme = SchemeSizes.fromData(
        contextPadding: contextPadding,
        data: data,
        fullHeight: fullHeight,
        height: height,
        width: width,
        size: size);

    //Station Sizes

    stationHeight = height(StationConstants.STATION_HEIGHT);

    stationTextHeight = height(StationConstants.TEXT_HEIGHT);
    stationTextWidth = width(StationConstants.TEXT_WIDTH);

    stationRoundIconSize = size(StationConstants.ROUND_ICON_WIDTH);
    stationRectIconHeight = height(StationConstants.WIDE_ICON_HEIGHT);
    stationRectIconWidth = width(StationConstants.WIDE_ICON_WIDTH);

    stationIconTextHeight = height(StationConstants.ICON_TEXT_HEIGHT);
    stationIconTextWidth = width(StationConstants.ICON_TEXT_WIDTH);

    stationIconTextPadding = width(StationConstants.SMALL_PADDING);
    stationTextPadding = height(StationConstants.BIG_PADDING);

    //Time Sizes

    timeHeight = height(TimeConstants.TIME_HEIGHT);
    timeLabelTextWidth = width(TimeConstants.LABEL_TEXT_WIDTH);
    timeTextWidth = width(TimeConstants.TIME_TEXT_WIDTH);
    timeLeftTextWidth = width(TimeConstants.TIME_LEFT_TEXT_WIDTH);

    //Schedule Sizes

    scheduleLeftPadding = width(MainScreenConstants.LEFT_PADDING);
    scheduleTopPadding =
        contextPadding.top + height(MainScreenConstants.TOP_PADDING);
    scheduleRightPadding =
        contextPadding.right + width(MainScreenConstants.RIGHT_PADDING);
    scheduleBottomPadding = contextPadding.bottom +
        height(NavPanelConstants.PANEL_HEIGHT +
            MainScreenConstants.BOTTOM_PADDING);

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

    navPanelHeight = height(NavPanelConstants.PANEL_HEIGHT);
    navPanelIconSize = size(NavPanelConstants.ICON_SIZE);
    navPanelInnerHorizontalPadding =
        width(NavPanelConstants.HORIZONTAL_PADDING);
    navPanelInnerBottomPadding = height(NavPanelConstants.BOTTOM_PADDING);
    navPanelInnerTopPadding = height(NavPanelConstants.TOP_PADDING);
    navPanelOuterHorizontalPadding =
        width(NavPanelConstants.OUTER_HORIZONTAL_PADDING);
    navPanelOuterBottomadding = width(NavPanelConstants.OUTER_BOTTOM_PADDING);
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
