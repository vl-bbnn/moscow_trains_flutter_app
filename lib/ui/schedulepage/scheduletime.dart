import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/schedulebloc.dart';
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

  selectTrainTime(ScheduleBloc scheduleBloc) {
    switch (type) {
      case QueryType.departure:
        return scheduleBloc.departureTime;
      case QueryType.arrival:
        return scheduleBloc.arrivalTime;
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalBloc = GlobalBloc.of(context);
    final textBloc = globalBloc.textBloc;
    if (status == Status.found)
      return StreamBuilder<DateTime>(
          stream: selectTrainTime(globalBloc.scheduleBloc),
          builder: (context, trainTimeSnapshot) {
            if (!trainTimeSnapshot.hasData) return Container();
            return StreamBuilder<DateTime>(
                stream: globalBloc.searchBloc.dateTime,
                builder: (context, selectedTimeSnapshot) {
                  if (!selectedTimeSnapshot.hasData) return Container();
                  final trainTime = trainTimeSnapshot.data;
                  final selectedTime = selectedTimeSnapshot.data;
                  final minutes =
                      Helper.timeDiffInMins(selectedTime, trainTime);
                  final shouldWarn = minutes != null && minutes < 5;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Time(
                        time: trainTime,
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
                                  .copyWith(
                                      fontSize: 10, color: MyColors.TEXT_SE),
                              textAlign: TextAlign.end,
                            ),
                          ),
                          TimeText(
                            time: minutes,
                            shouldWarn: shouldWarn,
                            textAlign: TextAlign.end,
                            align: Alignment.centerRight,
                          )
                        ],
                      ),
                    ],
                  );
                });
          });
    switch (type) {
      case QueryType.departure:
        return StreamBuilder<DateTime>(
            stream: globalBloc.searchBloc.dateTime,
            builder: (context, selectedTimeSnapshot) {
              if (!selectedTimeSnapshot.hasData) return Container();
              final trainTime = selectedTimeSnapshot.data;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Time(
                    time: trainTime,
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
            });
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
