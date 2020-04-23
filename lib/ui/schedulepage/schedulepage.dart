import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mysizes.dart';
import 'package:trains/ui/schedulepage/message.dart';
import 'package:trains/ui/schedulepage/scheduletime.dart';
import 'package:trains/ui/schedulepage/scheme/scheme.dart';
import 'package:trains/ui/schedulepage/stationcard.dart';
import 'package:trains/ui/schedulepage/trainselector.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final globalValues = GlobalValues.of(context);
    double oldPageValue = 0.0;

    final leftPadding = Helper.width(MainScreenSizes.LEFT_PADDING, size);
    final topPadding =
        padding.top + Helper.height(MainScreenSizes.TOP_PADDING, size);
    final rightPadding =
        padding.right + Helper.width(MainScreenSizes.RIGHT_PADDING, size);
    final bottomPadding = padding.bottom +
        Helper.height(
            NavPanelSizes.PANEL_HEIGHT + MainScreenSizes.BOTTOM_PADDING, size);

    final stationHeight = Helper.height(StationSizes.STATION_HEIGHT, size);
    final timeHeight = Helper.height(TimeSizes.TIME_HEIGHT, size);
    final trainSelectorHeight =
        Helper.height(SelectedTrainSizes.CARD_HEIGHT, size);
    final space = (size.height -
            topPadding -
            bottomPadding -
            2 * stationHeight -
            2 * timeHeight -
            trainSelectorHeight) /
        4;
    final selectorTopOffset =
        topPadding + stationHeight + space + timeHeight + space;
    final selectorBottomOffset =
        bottomPadding + stationHeight + space + timeHeight + space;
    return StreamBuilder<Status>(
        stream: globalValues.searchBloc.status,
        builder: (context, statusStream) {
          if (!statusStream.hasData) return Container();
          final status = statusStream.data;
          return StreamBuilder<double>(
              stream: globalValues.appNavigationBloc.pageValue,
              builder: (context, pageValueSnapshot) {
                // print("Schedule Page: " +
                //     (pageValueSnapshot.data ?? 0.0).toString());

                final pageValue = pageValueSnapshot.hasData
                    ? pageValueSnapshot.data
                    : oldPageValue;
                oldPageValue = pageValue;
                return Stack(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Scheme(status: status),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              leftPadding,
                              topPadding,
                              rightPadding,
                              bottomPadding,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: <Widget>[
                                SizedBox(
                                  height: stationHeight,
                                  child: StationCard(
                                    type: QueryType.departure,
                                  ),
                                ),
                                SizedBox(
                                  height: space,
                                ),
                                SizedBox(
                                  height: timeHeight,
                                  child: Center(
                                    child: ScheduleTime(
                                      type: QueryType.departure,
                                      status: status,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: space,
                                ),
                                SizedBox(
                                  height: trainSelectorHeight,
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
                                  height: space,
                                ),
                                SizedBox(
                                  height: timeHeight,
                                  child: Center(
                                    child: ScheduleTime(
                                      type: QueryType.arrival,
                                      status: status,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: space,
                                ),
                                SizedBox(
                                  height: stationHeight,
                                  child: Center(
                                    child: StationCard(
                                      type: QueryType.arrival,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    // Positioned.fill(
                    //   child: Column(
                    //     children: <Widget>[
                    //       Container(
                    //         height: topPadding,
                    //         width: size.width,
                    //         color: Colors.cyan.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: stationHeight,
                    //         width: size.width,
                    //         color: Colors.indigoAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: space,
                    //         width: size.width,
                    //         color: Colors.deepOrangeAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: timeHeight,
                    //         width: size.width,
                    //         color: Colors.greenAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: space,
                    //         width: size.width,
                    //         color: Colors.deepOrangeAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: trainSelectorHeight,
                    //         width: size.width,
                    //         color: Colors.limeAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: space,
                    //         width: size.width,
                    //         color: Colors.deepOrangeAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: timeHeight,
                    //         width: size.width,
                    //         color: Colors.greenAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: space,
                    //         width: size.width,
                    //         color: Colors.deepOrangeAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: stationHeight,
                    //         width: size.width,
                    //         color: Colors.indigoAccent.withOpacity(0.2),
                    //       ),
                    //       Container(
                    //         height: bottomPadding,
                    //         width: size.width,
                    //         color: Colors.cyan.withOpacity(0.2),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Positioned(
                      top: selectorTopOffset,
                      bottom: selectorBottomOffset,
                      child: Container(
                        width: size.width,
                        child: TrainSelector(),
                      ),
                    ),
                  ],
                );
              });
        });
  }
}
