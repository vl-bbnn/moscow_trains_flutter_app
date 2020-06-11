import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/schedulebloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/ui/schedulepage/message.dart';
import 'package:trains/ui/schedulepage/scheduletime.dart';
import 'package:trains/ui/schedulepage/scheme/scheme.dart';
import 'package:trains/ui/schedulepage/stationcard.dart';
import 'package:trains/ui/schedulepage/trains/trainselector.dart';

class SchedulePage extends StatelessWidget {
  final Sizes sizes;

  const SchedulePage({Key key, this.sizes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalBloc.of(context);

    return StreamBuilder<Status>(
        stream: globalValues.status,
        builder: (context, statusStream) {
          if (!statusStream.hasData) return Container();

          final status = statusStream.data;

          return Stack(
            children: <Widget>[
              StreamBuilder<Schedule>(
                  stream: globalValues.scheduleBloc.scheduleOutput,
                  builder: (context, scheduleSnapshot) {
                    if (!scheduleSnapshot.hasData) return Container();

                    final schedule = scheduleSnapshot.data;

                    // print("\n\n" + schedule.toString() + "\n");

                    return Row(
                      children: <Widget>[
                        Scheme(
                          status: status,
                          sizes: sizes,
                          schedule: schedule,
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              sizes.scheduleLeftPadding,
                              sizes.scheduleTopPadding,
                              sizes.scheduleRightPadding,
                              sizes.scheduleBottomPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: sizes.stationHeight,
                                  child: StationCard(
                                      type: QueryType.departure,
                                      station: schedule.from),
                                ),
                                SizedBox(
                                  height: sizes.scheduleSpace,
                                ),
                                SizedBox(
                                  height: sizes.timeHeight,
                                  child: Center(
                                    child: ScheduleTime(
                                      type: QueryType.departure,
                                      status: status,
                                      time: schedule.departure.time,
                                      minutesDiff:
                                          schedule.departure.minutesDiff,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: sizes.scheduleSpace,
                                ),
                                SizedBox(
                                  height: sizes.selectedTrain.cardHeight,
                                  child: status == Status.found
                                      ? Container()
                                      : Align(
                                          alignment: Alignment.centerLeft,
                                          child: Message(
                                            status: status,
                                          ),
                                        ),
                                ),
                                SizedBox(
                                  height: sizes.scheduleSpace,
                                ),
                                SizedBox(
                                  height: sizes.timeHeight,
                                  child: ScheduleTime(
                                      type: QueryType.arrival,
                                      status: status,
                                      time: schedule.arrival.time,
                                      minutesDiff:
                                          schedule.arrival.minutesDiff),
                                ),
                                SizedBox(
                                  height: sizes.scheduleSpace,
                                ),
                                SizedBox(
                                  height: sizes.stationHeight,
                                  child: Center(
                                    child: StationCard(
                                        type: QueryType.arrival,
                                        station: schedule.to),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
              // Positioned.fill(
              //   child: Column(
              //     children: <Widget>[
              //       Container(
              //         height: sizes.scheduleTopPadding,
              //         width: sizes.fullWidth,
              //         color: Colors.cyan.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.stationHeight,
              //         width: sizes.fullWidth,
              //         color: Colors.indigoAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.scheduleSpace,
              //         width: sizes.fullWidth,
              //         color: Colors.deepOrangeAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.timeHeight,
              //         width: sizes.fullWidth,
              //         color: Colors.greenAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.scheduleSpace,
              //         width: sizes.fullWidth,
              //         color: Colors.deepOrangeAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.selectedTrain.cardHeight,
              //         width: sizes.fullWidth,
              //         color: Colors.limeAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.scheduleSpace,
              //         width: sizes.fullWidth,
              //         color: Colors.deepOrangeAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.timeHeight,
              //         width: sizes.fullWidth,
              //         color: Colors.greenAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.scheduleSpace,
              //         width: sizes.fullWidth,
              //         color: Colors.deepOrangeAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.stationHeight,
              //         width: sizes.fullWidth,
              //         color: Colors.indigoAccent.withOpacity(0.2),
              //       ),
              //       Container(
              //         height: sizes.scheduleBottomPadding,
              //         width: sizes.fullWidth,
              //         color: Colors.cyan.withOpacity(0.2),
              //       ),
              //     ],
              //   ),
              // ),
              Positioned(
                top: sizes.scheduleSelectorTopOffset,
                bottom: sizes.scheduleSelectorBottomOffset,
                child: Container(
                  width: sizes.fullWidth,
                  child: status == Status.found
                      ? TrainSelector(
                          sizes: sizes,
                        )
                      : Container(),
                ),
              ),
            ],
          );
        });
  }
}
