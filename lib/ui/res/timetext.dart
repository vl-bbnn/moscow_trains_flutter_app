import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trains/ui/res/mycolors.dart';

class TimeText extends StatelessWidget {
  final text;
  final warn;

  const TimeText({Key key, this.text, this.warn = false}) : super(key: key);

  _textStyle(selected, specialOne, context) {
    if (selected)
      return Theme.of(context).textTheme.headline1.copyWith(
          fontSize: 18,
          color: warn ? MyColors.WARNING : MyColors.PRIMARY_TEXT,
          fontFeatures: specialOne ? [] : [FontFeature.enable('ss03')]);
    else
      return Theme.of(context).textTheme.headline1.copyWith(
          fontSize: 14,
          color: warn ? MyColors.WARNING_07 : MyColors.SECONDARY_TEXT);
  }

  @override
  Widget build(BuildContext context) {
    final specialOneMinutes = text['minutes'] == '1';
    final specialOneHours = text['hours'] == '1';
    if (text['hours'] == '0') {
      return RichText(
        text: TextSpan(children: [
          TextSpan(
              text: text['minutes'].toUpperCase(),
              style: _textStyle(true, specialOneMinutes, context)),
          TextSpan(
              text: " " + text['minutesText'].toUpperCase(),
              style: _textStyle(false, false, context)),
        ]),
      );
    } else if (text['minutes'] == '0')
      return RichText(
        text: TextSpan(children: [
          TextSpan(
              text: text['hours'].toUpperCase(),
              style: _textStyle(true, specialOneHours, context)),
          TextSpan(
              text: " " + text['hoursText'].toUpperCase(),
              style: _textStyle(false, false, context)),
        ]),
      );
    else
      return RichText(
        text: TextSpan(children: [
          TextSpan(
              text: text['hours'].toUpperCase(),
              style: _textStyle(true, specialOneHours, context)),
          TextSpan(
              text: " ч ".toUpperCase(),
              style: _textStyle(false, false, context)),
          TextSpan(
              text: text['minutes'].toUpperCase(),
              style: _textStyle(true, specialOneMinutes, context)),
          TextSpan(
              text: " мин".toUpperCase(),
              style: _textStyle(false, false, context)),
        ]),
      );
  }
}
