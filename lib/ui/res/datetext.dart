import 'package:flutter/material.dart';
import 'package:trains/src/helper.dart';

class DateText extends StatelessWidget {
  final DateTime date;

  const DateText({Key key, this.date}) : assert(date != null);

  @override
  Widget build(BuildContext context) {
    return Text(
      Helper.dateText(date).toUpperCase(),
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
