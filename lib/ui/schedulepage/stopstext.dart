import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';

class StopsText extends StatelessWidget {
  final stops;
  final width;
  final height;

  const StopsText({this.stops: 0, this.width, this.height});

  _textStyle(selected, context) {
    if (selected)
      return Theme.of(context).textTheme.headline1.copyWith(fontSize: 12);
    else
      return Theme.of(context)
          .textTheme
          .headline1
          .copyWith(fontSize: 10, color: MyColors.TEXT_SE);
  }

  @override
  Widget build(BuildContext context) {
    final hasData = stops != null;
    final text = Helper.stopsToText(stops);
    return Container(
      color: hasData ? null : Colors.lime,
      width: width,
      height: height,
      child: hasData
          ? AutoSizeText.rich(
              TextSpan(children: [
                TextSpan(
                    text: text['stops'] + " ".toUpperCase(),
                    style: _textStyle(true, context)),
                TextSpan(
                    text: text['stopsText'].toUpperCase(),
                    style: _textStyle(false, context)),
              ]),
              maxLines: 1,
              minFontSize: 2,
            )
          : Container(),
    );
  }
}
