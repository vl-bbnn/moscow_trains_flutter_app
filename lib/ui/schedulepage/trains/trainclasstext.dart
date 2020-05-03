import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/schedulepage/trains/traindot.dart';

class TrainClassText extends StatelessWidget {
  final train;
  final curvedValue;
  final Sizes sizes;

  _classText() {
    switch (train.trainClass) {
      case TrainClass.standart:
        return "Стандарт";
      case TrainClass.comfort:
        return "Комфорт";
      case TrainClass.express:
        return "Экспресс";
    }
  }

  TrainClassText({this.train, this.curvedValue, this.sizes});

  @override
  Widget build(BuildContext context) {
    final hasData = train != null;
    final textGroup = AutoSizeGroup();
    final classText = hasData ? _classText() : null;
    final price = hasData
        ? train.price != null ? (curvedValue * train.price).round() : 0
        : null;
    final priceTextWidth = sizes.selectedTrainPriceTextWidth * curvedValue;
    final dotPadding = sizes.selectedTrainIconPadding * curvedValue;
    final classTextWidth = sizes.selectedTrainClassTextWidth * curvedValue;
    final textHeight = sizes.selectedTrainTextHeight * curvedValue;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Expanded(
          child: Align(
            alignment: Alignment.lerp(
                Alignment.center, Alignment.centerLeft, curvedValue),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Opacity(
                  opacity: curvedValue,
                  child: Container(
                    color: hasData ? null : Colors.green,
                    width: classTextWidth,
                    height: textHeight,
                    child: hasData
                        ? AutoSizeText(
                            classText.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .headline1
                                .copyWith(fontSize: 12),
                            maxLines: 1,
                            minFontSize: 2,
                            group: textGroup,
                            textAlign: TextAlign.start,
                          )
                        : Container(),
                  ),
                ),
              ],
            ),
          ),
        ),
        Opacity(
          opacity: curvedValue,
          child: Container(
            color: hasData ? null : Colors.indigo,
            width: priceTextWidth,
            height: textHeight,
            child: hasData
                ? AutoSizeText(
                    price != 0 ? (price.toString() + " ₽").toUpperCase() : "",
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 12),
                    maxLines: 1,
                    minFontSize: 2,
                    group: textGroup,
                    textAlign: TextAlign.end,
                  )
                : Container(),
          ),
        ),
      ],
    );
  }
}
