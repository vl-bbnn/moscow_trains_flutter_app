import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/ui/res/mycolors.dart';

class Time extends StatelessWidget {
  final DateTime time;
  final bool warn;

  const Time({@required this.time, this.warn = false});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: DateFormat("H").format(time) + ":",
          style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: 36,
              color: warn ? MyColors.WARNING_07 : MyColors.SECONDARY_TEXT),
        ),
        TextSpan(
          text: DateFormat("mm").format(time),
          style: Theme.of(context).textTheme.headline1.copyWith(
              fontSize: 36,
              color: warn ? MyColors.WARNING : MyColors.PRIMARY_TEXT),
        )
      ]),
    );
  }
}
