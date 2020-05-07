import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/schedulebloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';

class DeselectedRoad extends StatelessWidget {
  final Status status;
  final Sizes sizes;
  final QueryType type;

  const DeselectedRoad({this.status, this.type, this.sizes});

  _backgroundColor() {
    switch (status) {
      case Status.searching:
      case Status.found:
        return MyColors.LE_B40;
      case Status.notFound:
        return MyColors.WA_B40;
    }
  }

  _foregroundColor(TrainClass trainClass) {
    switch (trainClass) {
      case TrainClass.standart:
        return MyColors.ST_B40;
      case TrainClass.comfort:
        return MyColors.D3_B40;
      case TrainClass.express:
        return MyColors.EX_B40;
    }
  }

  _fullHeight() {
    switch (type) {
      case QueryType.departure:
        return sizes.schemeDepartureHeight;
      case QueryType.arrival:
        return sizes.schemeleArrivalHeight;
    }
  }

  _valueStream(ScheduleBloc scheduleBloc) {
    switch (type) {
      case QueryType.departure:
        return scheduleBloc.departureValue;
      case QueryType.arrival:
        return scheduleBloc.arrivalValue;
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

  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalBloc.of(context);
    final valueStream = _valueStream(globalBloc.scheduleBloc);
    final stationStream = _stationStream(globalBloc.searchBloc);
    final selectedStream = _selectedStream(globalBloc.scheduleBloc);
    final fullHeight = _fullHeight();
    return StreamBuilder<Station>(
        stream: stationStream,
        builder: (context, stationSnapshot) {
          if (!stationSnapshot.hasData) return SizedBox();
          final terminal = stationSnapshot.data.terminal ?? false;
          final backColor = _backgroundColor();
          return Container(
            height: fullHeight,
            width: sizes.schemeLineWidth,
            color: terminal ? null : backColor,
            child: StreamBuilder<bool>(
                stream: selectedStream,
                builder: (context, selectedSnapshot) {
                  final selected = selectedSnapshot.data ?? true;
                  return StreamBuilder<TrainClass>(
                      stream: globalBloc.scheduleBloc.trainClass,
                      builder: (context, trainClassSnapshot) {
                        if (!trainClassSnapshot.hasData) return Container();
                        final trainClass = trainClassSnapshot.data;
                        final foreColor = _foregroundColor(trainClass);
                        return StreamBuilder<double>(
                            stream: valueStream,
                            builder: (context, valueSnapshot) {
                              final value = valueSnapshot.hasData
                                  ? valueSnapshot.data
                                  : 0.0;
                              return Container(
                                child: status == Status.found && !selected
                                    ? Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                          height: fullHeight * value,
                                          color: foreColor,
                                        ),
                                      )
                                    : SizedBox(),
                              );
                            });
                      });
                }),
          );
        });
  }
}
