import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';

class TrainClassText extends StatelessWidget {
  final TrainClass trainClass;
  final int price;

  _classText() {
    switch (trainClass) {
      case TrainClass.standart:
        return "Стандарт";
      case TrainClass.comfort:
        return "Комфорт";
      case TrainClass.express:
        return "Экспресс";
    }
  }

  TrainClassText({this.trainClass, this.price});

  @override
  Widget build(BuildContext context) {
    final textGroup = AutoSizeGroup();
    final classText = _classText();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        AutoSizeText(
          classText.toUpperCase(),
          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 12),
          maxLines: 1,
          minFontSize: 2,
          group: textGroup,
          textAlign: TextAlign.start,
        ),
        AutoSizeText(
          price != 0 ? (price.toString() + " ₽").toUpperCase() : "",
          style: Theme.of(context).textTheme.headline1.copyWith(fontSize: 12),
          maxLines: 1,
          minFontSize: 2,
          group: textGroup,
          textAlign: TextAlign.end,
        ),
      ],
    );
  }
}
