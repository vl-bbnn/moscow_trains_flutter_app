import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/timetext.dart';

class BreakText extends StatelessWidget {
  final int breakTime;

  const BreakText({Key key, this.breakTime}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final group = GlobalBloc.of(context).textBloc.smallTimeText;

    if (breakTime == 0)
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          AutoSizeText(
            "в то же".toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            group: group,
            minFontSize: 8,
            style: Theme.of(context)
                .textTheme
                .headline1
                .copyWith(fontSize: 10.0, color: MyColors.TEXT_SE),
          ),
          AutoSizeText(
            "время".toUpperCase(),
            textAlign: TextAlign.center,
            maxLines: 1,
            group: group,
            minFontSize: 8,
            style:
                Theme.of(context).textTheme.headline1.copyWith(fontSize: 12.0),
          ),
        ],
      );

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        AutoSizeText(
          "позже на".toUpperCase(),
          textAlign: TextAlign.center,
          maxLines: 1,
          group: group,
          minFontSize: 8,
          style: Theme.of(context)
              .textTheme
              .headline1
              .copyWith(fontSize: 10.0, color: MyColors.TEXT_SE),
        ),
        TimeText(
          textAlign: TextAlign.center,
          align: Alignment.center,
          time: breakTime,
          short: true,
          animated: true,
          shouldWarn: breakTime > 15,
        ),
      ],
    );
  }
}
