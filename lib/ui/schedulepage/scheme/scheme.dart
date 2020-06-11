import 'package:flutter/material.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/schedulebloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/ui/schedulepage/scheme/roadpath.dart';
import 'package:trains/ui/schedulepage/scheme/stationicon.dart';
import 'package:trains/ui/schedulepage/scheme/terminalstation.dart';
import 'package:trains/ui/schedulepage/scheme/trainpath.dart';

class Scheme extends StatelessWidget {
  final Status status;
  final Sizes sizes;
  final Schedule schedule;

  const Scheme({this.status, this.sizes, this.schedule});

  @override
  Widget build(BuildContext context) {
    final scheme = sizes.scheme;
    return SizedBox(
      height: sizes.fullHeight,
      child: Row(
        children: <Widget>[
          SizedBox(
            width: scheme.leftPadding,
          ),
          SizedBox(
              width: scheme.textWidth,
              child: Padding(
                padding: EdgeInsets.only(
                    top: scheme.textTopPadding + sizes.topPadding,
                    bottom: scheme.textBottomPadding + sizes.bottomPadding),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    TerminalStation(
                      sizes: sizes,
                      status: status,
                      type: QueryType.departure,
                      roadValue: schedule.roadValue,
                      station: schedule.departure.station,
                      selected: schedule.departure.selected,
                    ),
                    TerminalStation(
                      sizes: sizes,
                      status: status,
                      type: QueryType.arrival,
                      roadValue: schedule.roadValue,
                      station: schedule.arrival.station,
                      selected: schedule.arrival.selected,
                    ),
                  ],
                ),
              )),
          SizedBox(
            width: scheme.textPadding,
          ),
          Stack(
            children: <Widget>[
              SizedBox(
                width: scheme.totalWidth,
                child: Padding(
                  padding: EdgeInsets.only(
                      left: scheme.lineLeftPadding,
                      right: scheme.lineRightPadding),
                  child: Column(
                    children: <Widget>[
                      RoadPath(
                          sizes: sizes,
                          status: status,
                          type: QueryType.departure,
                          trainClass: schedule.trainClass,
                          roadValue: schedule.roadValue,
                          terminal: schedule.from.terminal,
                          selected: schedule.departure.selected),
                      TrainPath(
                        status: status,
                        sizes: sizes,
                        type: QueryType.departure,
                        trainClass: schedule.trainClass,
                        trainValue: schedule.trainValue,
                      ),
                      TrainPath(
                        status: status,
                        sizes: sizes,
                        type: QueryType.arrival,
                        trainClass: schedule.trainClass,
                        trainValue: schedule.trainValue,
                      ),
                      RoadPath(
                          sizes: sizes,
                          status: status,
                          type: QueryType.arrival,
                          trainClass: schedule.trainClass,
                          roadValue: schedule.roadValue,
                          terminal: schedule.to.terminal,
                          selected: schedule.arrival.selected),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: scheme.departureRoadHeight - scheme.iconSize / 2,
                bottom: scheme.arrivalRoadHeight - scheme.iconSize / 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    StationIcon(
                      sizes: sizes,
                      status: status,
                      type: QueryType.departure,
                      trainClass: schedule.trainClass,
                      iconValue: schedule.iconValue,
                      station: schedule.departure.station,
                      selected: schedule.departure.selected,
                    ),
                    StationIcon(
                      sizes: sizes,
                      status: status,
                      type: QueryType.arrival,
                      trainClass: schedule.trainClass,
                      iconValue: schedule.iconValue,
                      station: schedule.arrival.station,
                      selected: schedule.arrival.selected,
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
