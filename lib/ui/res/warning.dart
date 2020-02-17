import 'package:flutter/material.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/res/mycolors.dart';

class Warning extends StatelessWidget {
  final int diff;
  final bool first;
  final bool last;
  final bool betweenTrains;

  const Warning({
    Key key,
    @required this.last,
    @required this.diff,
    @required this.first,
    @required this.betweenTrains,
  }) : super(key: key);

  _labelText() {
    if (diff == 0) return "";
    if (betweenTrains) return "";
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
    if (diff == 0 ||
        (betweenTrains && diff.abs() >= 10) ||
        diff.abs() >= 25)
      return MyColors.WARNING;
    else
      return MyColors.BLACK;
  }

  _divider() {
    return Container(
      height: 2,
      decoration: ShapeDecoration(
          color: MyColors.SECONDARY,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(1))),
    );
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

  _betweenTrainsDivider(context) {
    if (!last && diff.abs() < 5) return Center(child: _divider());
    return Row(
      children: <Widget>[
        Expanded(
          child: _divider(),
        ),
        SizedBox(
          width: 20,
        ),
        if (last)
          Text(
            "последний поезд".toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(color: MyColors.WARNING),
          )
        else
          RichText(
            textAlign: TextAlign.center,
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
          ),
        SizedBox(
          width: 20,
        ),
        Expanded(
          child: _divider(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (betweenTrains || last) {
      if (first) return Container();
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: SizedBox(
          width: 225,
          child: _betweenTrainsDivider(context),
        ),
      );
    }
    return _text(context);
  }
}
