import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/time.dart';
import 'package:trains/ui/common/timetext.dart';

class ScheduleTime extends StatelessWidget {
  final QueryType type;
  final Status status;

  const ScheduleTime({this.type, this.status})
      : assert(type != null && status != null);

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

  selectTime() {
    switch (status) {
      case Status.searching:
      case Status.notFound:
        switch (type) {
          case QueryType.departure:
            return "currentTime";
          case QueryType.arrival:
            return null;
        }
        break;
      case Status.found:
        switch (type) {
          case QueryType.departure:
            return 'departureTime';
          case QueryType.arrival:
            return 'arrivalTime';
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalValues = GlobalValues.of(context);
    final textBloc = globalValues.textBloc;
    return StreamBuilder<Map<String, dynamic>>(
        stream: globalValues.scheduleBloc.timeMap,
        builder: (context, timeMapSnapshot) {
          if (!timeMapSnapshot.hasData) return Container();
          final timeMap = timeMapSnapshot.data;
          final selected = selectTime();
          final selectedTime =
              selected != null ? timeMap[selected.toString()] : null;
          final minutes = status == Status.found
              ? Helper.timeDiffInMins(timeMap['currentTime'], selectedTime)
              : null;
          final shouldWarn = minutes != null && minutes < 5;
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Time(
                time: selectedTime,
                warn: shouldWarn,
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
                  minutes != null
                      ? TimeText(
                          time: minutes,
                          shouldWarn: shouldWarn,
                          textAlign: TextAlign.end,
                          align: Alignment.centerRight,
                        )
                      : SizedBox(
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
        });
  }
}
