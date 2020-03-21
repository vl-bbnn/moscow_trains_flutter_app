import 'package:flutter/material.dart';
import 'package:trains/ui/res/mycolors.dart';

class StopsText extends StatelessWidget {
  final text;

  const StopsText({Key key, this.text}) : super(key: key);

  _textStyle(selected, context) {
    if (selected)
      return Theme.of(context).textTheme.headline1.copyWith(fontSize: 18);
    else
      return Theme.of(context)
          .textTheme
          .headline1
          .copyWith(fontSize: 14, color: MyColors.SECONDARY_TEXT);
  }

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
            text: text['stops'] + " ".toUpperCase(),
            style: _textStyle(true, context)),
        TextSpan(
            text: text['stopsText'].toUpperCase(),
            style: _textStyle(false, context)),
      ]),
    );
  }
}
