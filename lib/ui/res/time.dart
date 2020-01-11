import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/src/constants.dart';

class Time extends StatelessWidget {

final DateTime time;
final TextAlign align;

  const Time({Key key, @required this.time, @required this.align}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.PADDING_SMALL),
      child: RichText(
        textAlign: align,
        text: TextSpan(children: [
          TextSpan(
            text: DateFormat("H").format(time),
            style: TextStyle(
                fontSize: 30,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w800,
                color: Constants.GREY),
          ),
          TextSpan(
            text:" ",
            style: TextStyle(
                fontSize: 18,),
          ),
          TextSpan(
            text:DateFormat("mm").format(time),
            style: TextStyle(
                fontSize: 24,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600,
                color: Constants.WHITE),
          )
        ]),
      ),
    );
  }
}