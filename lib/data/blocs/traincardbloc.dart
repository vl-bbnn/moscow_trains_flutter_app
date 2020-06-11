import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'dart:math' as math;

class TrainCardValues {
  TrainClass trainClass;

  int stops;
  int price;

  int travelTime;
  int breakTime;

  double value;

  double _primaryTextLevel = 0.3;
  double primaryTextValue;

  double _cardSizeLevel = 0.4;
  double cardSizeValue;

  double _iconMoveLevel = 0.2;
  double _iconElevationLevel = 0.1;
  double _iconLabelOpacityLevel = 0.1;
  double _iconMoveValue;
  double _iconElevationValue;
  double _iconlabelOpacityValue;

  double _secondaryTextLevel = 0.3;
  double secondaryTextValue;

  double cardHeight;
  double cardWidth;
  double selectedWidth;
  BorderRadius borderRadius;

  Color color;
  double sigma;

  double iconAngle;
  double iconFrontWidth;
  double iconFrontHeight;
  double iconFrontOpacity;
  double iconBackWidth;
  double iconBackHeight;
  double iconBackSigma;

  EdgeInsets innerPadding;
  EdgeInsets outerPadding;

  double primaryTextWidth;
  double secondaryTextHeight;
  double textPadding;

  double regularIconTextPadding;
  double selectedIconTextPadding;

  TrainCardValues.fromValue(
      {double newValue,
      TrainClass finalTrainClass,
      int finalPrice,
      int finalTravelTime,
      int finalBreakTime,
      int finalStops,
      Sizes sizes}) {
    value = newValue;
    //Values
    secondaryTextValue =
        1 - newValue.clamp(0.0, _secondaryTextLevel) / _secondaryTextLevel;

    _iconMoveValue =
        (newValue - _secondaryTextLevel).clamp(0.0, _iconMoveLevel) /
            _iconMoveLevel;

    _iconlabelOpacityValue = (newValue - _secondaryTextLevel - _iconMoveLevel)
            .clamp(0.0, _iconLabelOpacityLevel) /
        _iconLabelOpacityLevel;

    _iconElevationValue = (newValue -
                _secondaryTextLevel -
                _iconLabelOpacityLevel -
                _iconMoveLevel)
            .clamp(0.0, _iconElevationLevel) /
        _iconElevationLevel;

    cardSizeValue =
        (newValue - _secondaryTextLevel).clamp(0.0, _cardSizeLevel) /
            _cardSizeLevel;

    primaryTextValue = (newValue - _secondaryTextLevel - _cardSizeLevel)
            .clamp(0.0, _primaryTextLevel) /
        _primaryTextLevel;

    //Train Data
    trainClass = finalTrainClass;

    price = finalPrice;
    stops = price;
    travelTime = finalTravelTime;
    breakTime = finalBreakTime;

    // price = (primaryTextValue * finalPrice).round();
    // stops = price;
    // travelTime = (finalTravelTime * primaryTextValue).round();
    // breakTime = (finalBreakTime * secondaryTextValue).round();

    //Widgets Data

    cardHeight = sizes.regularTrain.cardHeight +
        cardSizeValue *
            (sizes.selectedTrain.cardHeight - sizes.regularTrain.cardHeight);
    cardWidth = sizes.regularTrain.cardWidth +
        cardSizeValue *
            (sizes.selectedTrain.cardWidth - sizes.regularTrain.cardWidth);
    selectedWidth = sizes.regularTrain.cardWidth +
        newValue *
            (sizes.selectedTrain.cardWidth - sizes.regularTrain.cardWidth);
    borderRadius = BorderRadius.circular(12 + cardSizeValue * (18 - 12));

    color = Color.lerp(MyColors.BACK_SE, MyColors.BACK_EL, cardSizeValue)
        .withOpacity(0.5);
    sigma = 0.5 * cardSizeValue;

    iconAngle = -math.pi / 2 * _iconMoveValue;
    iconFrontWidth = sizes.regularTrain.iconWidth;
    iconFrontHeight = sizes.regularTrain.iconHeight;
    iconFrontOpacity = _iconlabelOpacityValue;
    iconBackWidth =
        sizes.regularTrain.iconWidth * (_iconElevationValue * 0.5 + 1);
    iconBackHeight =
        sizes.regularTrain.iconHeight * (_iconElevationValue * 0.5 + 1);
    iconBackSigma = _iconElevationValue * 10;

    final regularPadding = EdgeInsets.symmetric(
        horizontal: sizes.regularTrain.horizontalPadding,
        vertical: sizes.regularTrain.verticalPadding);
    final selectedPadding = EdgeInsets.fromLTRB(
      sizes.selectedTrain.leftPadding,
      sizes.selectedTrain.verticalPadding,
      sizes.selectedTrain.rightPadding,
      sizes.selectedTrain.verticalPadding,
    );

    innerPadding =
        EdgeInsets.lerp(regularPadding, selectedPadding, cardSizeValue);
    outerPadding =
        EdgeInsets.symmetric(horizontal: sizes.regularTrain.outerPadding);

    textPadding = sizes.selectedTrain.textPadding * primaryTextValue;
    primaryTextWidth = sizes.selectedTrain.textWidth * cardSizeValue;
    secondaryTextHeight = sizes.regularTrain.textHeight * (1 - cardSizeValue);

    regularIconTextPadding =
        sizes.regularTrain.iconTextPadding * (1 - cardSizeValue);
    selectedIconTextPadding =
        sizes.selectedTrain.iconTextPadding * cardSizeValue;
  }
}

class TrainCardBloc extends InheritedWidget {
  final values = BehaviorSubject<TrainCardValues>();

  TrainCardBloc(
      {Train train,
      DateTime otherTrainDeparture,
      ValueNotifier<double> valueInput,
      Sizes sizes,
      Widget child})
      : super(child: child) {
    final finalTrainClass = train.trainClass;

    final finalPrice = train.price ?? 0;
    final finalStops = finalPrice;

    final finalTravelTime =
        Helper.timeDiffInMins(train.departure, train.arrival);
    final finalBreakTime = otherTrainDeparture != null
        ? Helper.timeDiffInMins(train.departure, otherTrainDeparture)
        : 0;

    values.add(TrainCardValues.fromValue(
        newValue: valueInput.value,
        finalTrainClass: finalTrainClass,
        finalBreakTime: finalBreakTime,
        finalPrice: finalPrice,
        finalStops: finalStops,
        finalTravelTime: finalTravelTime,
        sizes: sizes));

    valueInput.addListener(() {
      values.add(TrainCardValues.fromValue(
          newValue: valueInput.value,
          finalTrainClass: finalTrainClass,
          finalBreakTime: finalBreakTime,
          finalPrice: finalPrice,
          finalStops: finalStops,
          finalTravelTime: finalTravelTime,
          sizes: sizes));
    });
  }

  static TrainCardBloc of(context) {
    return (context.inheritFromWidgetOfExactType(TrainCardBloc)
        as TrainCardBloc);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  close() {
    values.close();
  }
}
