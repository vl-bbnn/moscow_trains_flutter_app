import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/ui/res/mycolors.dart';

class Time extends StatelessWidget {
  final DateTime time;
  final TextAlign align;

  const Time({Key key, @required this.time, @required this.align})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
      textAlign: align,
      text: TextSpan(children: [
        TextSpan(
          text: DateFormat("H").format(time) + ":",
          style: TextStyle(
              fontFeatures: [FontFeature.enable('ss03')],
              fontSize: 30,
              fontFamily: "Moscow Sans",
              color: MyColors.GREY),
        ),
        TextSpan(
          text: DateFormat("mm").format(time),
          style: TextStyle(
              fontFeatures: [FontFeature.enable('ss03')],
              fontSize: 30,
              fontFamily: "Moscow Sans",
              color: MyColors.BLACK),
        )
      ]),
    );
  }
}
