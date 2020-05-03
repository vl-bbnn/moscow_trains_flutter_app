import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/schedulebloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/mysizes.dart';

class StationIcon extends StatelessWidget {
  final Status status;
  final QueryType type;
  final Sizes sizes;

  const StationIcon(
      {this.type: QueryType.departure,
      this.status: Status.notFound,
      this.sizes});

  _valueStream(ScheduleBloc scheduleBloc) {
    switch (type) {
      case QueryType.departure:
        return scheduleBloc.departureIconValue;
      case QueryType.arrival:
        return scheduleBloc.arrivalIconValue;
    }
  }

  _selectedStream(ScheduleBloc scheduleBloc) {
    switch (type) {
      case QueryType.departure:
        return scheduleBloc.departureSelected;
      case QueryType.arrival:
        return scheduleBloc.arrivalSelected;
    }
  }

  _stationStream(SearchBloc searchBloc) {
    switch (type) {
      case QueryType.departure:
        return searchBloc.fromStation;
      case QueryType.arrival:
        return searchBloc.toStation;
    }
  }

  _backgroundColor() {
    switch (status) {
      case Status.searching:
      case Status.found:
        return MyColors.LE;
      case Status.notFound:
        return MyColors.WA;
    }
  }

  _foregroundColor(TrainClass trainClass) {
    switch (trainClass) {
      case TrainClass.standart:
        return MyColors.ST;
      case TrainClass.comfort:
        return MyColors.D3;
      case TrainClass.express:
        return MyColors.EX;
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalBloc.of(context);
    final backColor = _backgroundColor();

    final lineWidth = sizes.schemeLineWidth;

    final onTop = type == QueryType.departure;
    final stopRadius = BorderRadius.only(
        topLeft: Radius.circular(onTop ? lineWidth / 2 : 0),
        bottomLeft: Radius.circular(onTop ? 0 : lineWidth / 2),
        topRight: Radius.circular(2),
        bottomRight: Radius.circular(2));
    final terminalRadius = BorderRadius.circular(2);

    final stopPadding =
        EdgeInsets.fromLTRB(lineWidth / 2, lineWidth / 2, 0, lineWidth / 2);
    final terminalPadding =
        EdgeInsets.fromLTRB(0, lineWidth / 2, lineWidth / 2, lineWidth / 2);

    return StreamBuilder<Station>(
        stream: _stationStream(globalBloc.searchBloc),
        builder: (context, stationSnapshot) {
          if (!stationSnapshot.hasData) return Container();

          final roadTerminal = stationSnapshot.data.terminal;
          final hasTransit = stationSnapshot.data.transitList.isNotEmpty;
          final zeroRadius = roadTerminal ? terminalRadius : stopRadius;
          final zeroPadding = roadTerminal ? terminalPadding : stopPadding;

          return StreamBuilder<TrainClass>(
              stream: globalBloc.scheduleBloc.trainClass,
              builder: (context, trainClassSnapshot) {
                if (!trainClassSnapshot.hasData) return Container();

                final trainClass = trainClassSnapshot.data;
                final foreColor = _foregroundColor(trainClass);

                return StreamBuilder<bool>(
                    stream: _selectedStream(globalBloc.scheduleBloc),
                    builder: (context, selectedSnapshot) {
                      if (!selectedSnapshot.hasData) return Container();

                      final selected = selectedSnapshot.data;
                      final finalRadius =
                          selected ? terminalRadius : stopRadius;
                      final finalPadding =
                          selected ? terminalPadding : stopPadding;

                      return Container(
                        child: StreamBuilder<double>(
                            stream: _valueStream(globalBloc.scheduleBloc),
                            builder: (context, valueSnapshot) {
                              if (!valueSnapshot.hasData) return Container();

                              final value = valueSnapshot.data;
                              final radius = BorderRadius.lerp(
                                  zeroRadius, finalRadius, value);
                              final padding = EdgeInsets.lerp(
                                  zeroPadding, finalPadding, value);
                              final color =
                                  Color.lerp(backColor, foreColor, value);

                              if (hasTransit)
                                return Padding(
                                  padding:
                                      EdgeInsets.only(right: lineWidth / 2),
                                  child: Container(
                                    decoration: ShapeDecoration(
                                        shape: CircleBorder(), color: color),
                                    width: lineWidth * 2,
                                    height: lineWidth * 2,
                                    child: Center(
                                      child: Container(
                                        width: lineWidth,
                                        height: lineWidth,
                                        decoration: ShapeDecoration(
                                            shape: CircleBorder(),
                                            color: MyColors.BACK_PR),
                                      ),
                                    ),
                                  ),
                                );

                              return Padding(
                                padding: padding,
                                child: Container(
                                  width: lineWidth * 2,
                                  height: lineWidth,
                                  decoration: ShapeDecoration(
                                      color: color,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: radius)),
                                ),
                              );
                            }),
                      );
                    });
              });
        });
  }
}
