import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class WarningCard extends StatelessWidget {
  final int diff;
  final bool first;
  final bool last;

  const WarningCard(
      {Key key, @required this.last, @required this.diff, @required this.first})
      : super(key: key);

  _labelText() {
    if (diff < 0)
      return "раньше на";
    else
      return "через";
  }

  _text(context) {
    final text = diff == 0 ? "сейчас" : Helper.minutesToText(diff)['shortText'];
    final color = diff.abs() >= 15 || diff == 0
        ? Constants.NEGATIVE_FOREGROUND
        : Constants.GREY;
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        first && diff != 0
            ? Text(
                _labelText(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.button,
              )
            : Container(),
        Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }

  _divider() {
    return Padding(
      padding: const EdgeInsets.all(Constants.PADDING_BIG),
      child: Container(
        height: 2,
        decoration: ShapeDecoration(
            color: Constants.SECONDARY,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
      ),
    );
  }

  _body(context) {
    if (last || first || diff != 0) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: _divider(),
          ),
          last
              ? Text(
                  "последний\nпоезд",
                  textAlign: TextAlign.center,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(color: Constants.NEGATIVE_FOREGROUND),
                )
              : _text(context),
          Expanded(
            child: _divider(),
          ),
        ],
      );
    } else
      return Container(
        child: Center(
          child: _divider(),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Container(width: Constants.TRAINCARD_WIDTH, child: _body(context));
  }
}
