import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/res/mycolors.dart';
import 'package:trains/ui/res/time.dart';
import 'package:trains/ui/res/timetext.dart';

class MainScreenTime extends StatelessWidget {
  final QueryType type;

  const MainScreenTime({Key key, this.type}) : super(key: key);

  _time(Train train) {
    switch (type) {
      case QueryType.departure:
        return train.departure;
      case QueryType.arrival:
        return train.arrival;
    }
  }

  _shouldWarn(minutes) {
    switch (type) {
      case QueryType.departure:
        return minutes < 5 || minutes > 25;
      case QueryType.arrival:
        return minutes < 5;
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    return StreamBuilder<Train>(
        stream: globalValues.trainsBloc.selected,
        builder: (context, selectedStream) {
          return StreamBuilder<DateTime>(
              stream: globalValues.searchBloc.dateTime,
              builder: (context, dateTimeStream) {
                if (!selectedStream.hasData || !dateTimeStream.hasData)
                  return Container();
                final time = _time(selectedStream.data);
                final targetTime = dateTimeStream.data;
                final minutes = Helper.timeDiffInMins(targetTime, time);
                final text = Helper.minutesToText(minutes);
                final warn = _shouldWarn(minutes);
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Time(
                      time: time,
                      warn: warn,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          "через".toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headline1
                              .copyWith(
                                  fontSize: 12,
                                  color: MyColors.SECONDARY_TEXT),
                        ),
                        TimeText(
                          text: text,
                          warn: warn,
                        ),
                      ],
                    ),
                  ],
                );
              });
        });
  }
}
