import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/src/constants.dart';

class Time extends StatelessWidget {
  final DateTime time;
  final TextAlign align;
  final small;

  const Time(
      {Key key, @required this.time, @required this.align, this.small = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: small ? Constants.TIME_WIDTH_SMALL : Constants.TIME_WIDTH,
      child: RichText(
        textAlign: align,
        text: TextSpan(children: [
          TextSpan(
            text: DateFormat("H").format(time) + ":",
            style: TextStyle(
                fontFeatures: [FontFeature.enable('ss03')],
                fontSize: small ? 24 : 30,
                fontFamily: "Moscow Sans",
                color: Constants.GREY),
          ),
          TextSpan(
            text: DateFormat("mm").format(time),
            style: TextStyle(
                fontFeatures: [FontFeature.enable('ss03')],
                fontSize: small ? 24 : 30,
                fontFamily: "Moscow Sans",
                color: Constants.WHITE),
          )
        ]),
      ),
    );
  }
}
