import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/time.dart';
import 'package:trains/ui/common/timetext.dart';

class ScheduleTime extends StatelessWidget {
  final QueryType type;
  final Status status;
  final DateTime time;
  final DateTime targetTime;
  final int minutesDiff;

  const ScheduleTime(
      {this.type, this.status, this.time, this.minutesDiff, this.targetTime});

  timeLabel() {
    switch (status) {
      case Status.searching:
      case Status.notFound:
        switch (type) {
          case QueryType.departure:
            return "отправлением";
          case QueryType.arrival:
            return "прибытием";
        }
        break;
      case Status.found:
        return "через";
        break;
    }
  }

  timeText() {
    switch (type) {
      case QueryType.departure:
        return "сейчас";
      case QueryType.arrival:
        return "не важно";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textBloc = GlobalBloc.of(context).textBloc;

    if (status == Status.found) {
      final shouldWarn = minutesDiff != null && minutesDiff < 5;

      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Time(
            time: time,
            warn: shouldWarn,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: Helper.width(90, size),
                child: AutoSizeText(
                  timeLabel().toUpperCase(),
                  maxLines: 1,
                  group: textBloc.timeSubtitle,
                  style: Theme.of(context)
                      .textTheme
                      .headline1
                      .copyWith(fontSize: 10, color: MyColors.TEXT_SE),
                  textAlign: TextAlign.end,
                ),
              ),
              TimeText(
                time: minutesDiff,
                shouldWarn: shouldWarn,
                textAlign: TextAlign.end,
                align: Alignment.centerRight,
              )
            ],
          ),
        ],
      );
    }

    switch (type) {
      case QueryType.departure:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Time(
              time: targetTime,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: Helper.width(90, size),
                  child: AutoSizeText(
                    timeLabel().toUpperCase(),
                    maxLines: 1,
                    group: textBloc.timeSubtitle,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 10, color: MyColors.TEXT_SE),
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(
                  width: Helper.width(110, size),
                  child: AutoSizeText(
                    timeText().toUpperCase(),
                    maxLines: 1,
                    group: textBloc.regularTimeText,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 18),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        );

      case QueryType.arrival:
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Time(
              time: null,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                SizedBox(
                  width: Helper.width(90, size),
                  child: AutoSizeText(
                    timeLabel().toUpperCase(),
                    maxLines: 1,
                    group: textBloc.timeSubtitle,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 10, color: MyColors.TEXT_SE),
                    textAlign: TextAlign.end,
                  ),
                ),
                SizedBox(
                  width: Helper.width(110, size),
                  child: AutoSizeText(
                    timeText().toUpperCase(),
                    maxLines: 1,
                    group: textBloc.regularTimeText,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 18),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ],
        );
    }
    return Container();
  }
}
