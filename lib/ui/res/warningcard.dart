import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class WarningCard extends StatelessWidget {
  final int diff;
  final bool first;
  final bool last;
  final bool betweenTrains;

  const WarningCard({
    Key key,
    @required this.last,
    @required this.diff,
    @required this.first,
    @required this.betweenTrains,
  }) : super(key: key);

  _labelText() {
    if (diff == 0) return "";
    if (betweenTrains) return "перерыв ";
    if (diff < 0)
      return "раньше на ";
    else if (!betweenTrains)
      return "через ";
    else
      return "позже на ";
  }

  _timeText() {
    if (diff == 0)
      return "сейчас";
    else
      return Helper.minutesToText(diff)['fullText'];
  }

  _timeTextColor() {
    if (diff == 0 || diff.abs() >= Constants.WARNINGAFTER)
      return Constants.WARNING;
    else
      return Constants.WHITE;
  }

  _text(context) {
    return RichText(
      textAlign: TextAlign.start,
      text: TextSpan(children: [
        TextSpan(
            text: _labelText().toUpperCase(),
            style: Theme.of(context).textTheme.headline2),
        TextSpan(
            text: _timeText().toUpperCase(),
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: _timeTextColor())),
      ]),
    );
  }

  _body(context) {
    if (last) {
      return Text(
        "последний поезд".toUpperCase(),
        textAlign: TextAlign.center,
        style: Theme.of(context)
            .textTheme
            .headline2
            .copyWith(color: Constants.WARNING),
      );
    } else
      return _text(context);
  }

  @override
  Widget build(BuildContext context) {
    if (betweenTrains && (first || diff.abs() < 10))
      return SizedBox(
        height: 25,
      );
    if (!betweenTrains && diff.abs() > 90) return Container();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: betweenTrains || last ? 25 : 0,
        ),
        Row(
          children: <Widget>[
            SizedBox(
              width: betweenTrains || last ? 33 : 0,
            ),
            _body(context),
          ],
        ),
        SizedBox(
          height: 25,
        ),
      ],
    );
  }
}
