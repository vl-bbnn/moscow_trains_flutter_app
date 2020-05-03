import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/schedulebloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/ui/common/mycolors.dart';

class TerminalStation extends StatelessWidget {
  final Status status;
  final QueryType type;
  final Sizes sizes;

  const TerminalStation(
      {this.status: Status.notFound,
      this.type: QueryType.departure,
      this.sizes});

  _alignment() {
    switch (type) {
      case QueryType.departure:
        return TextAlign.end;
      case QueryType.arrival:
        return TextAlign.start;
    }
  }

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

  _stationStream(ScheduleBloc scheduleBloc) {
    switch (type) {
      case QueryType.departure:
        return scheduleBloc.departureStation;
      case QueryType.arrival:
        return scheduleBloc.arrivalStation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalBloc.of(context);

    final align = _alignment();

    final fullHeight = sizes.schemeTextWidth;
    final fullWidth = sizes.schemeTextHeight;

    return StreamBuilder<bool>(
        stream: _selectedStream(globalBloc.scheduleBloc),
        builder: (context, selectedSnapshot) {
          if (!selectedSnapshot.hasData) return Container();

          final selected = selectedSnapshot.data;

          if (status != Status.found || selected) return Container();

          return StreamBuilder<Station>(
              stream: _stationStream(globalBloc.scheduleBloc),
              builder: (context, stationSnapshot) {
                if (!stationSnapshot.hasData) return Container();

                final name = stationSnapshot.data.title;

                return StreamBuilder<double>(
                    stream: _valueStream(globalBloc.scheduleBloc),
                    builder: (context, valueSnapshot) {
                      if (!valueSnapshot.hasData) return Container();

                      final value = valueSnapshot.data;

                      final width = value * fullWidth;
                      final height = value * fullHeight;

                      return RotatedBox(
                          quarterTurns: 3,
                          child: Opacity(
                            opacity: value,
                            child: Container(
                                width: width,
                                height: height,
                                child: AutoSizeText(
                                  name,
                                  textAlign: align,
                                  maxLines: 1,
                                  minFontSize: 2,
                                  group: globalBloc.textBloc.terminalStations,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                          fontSize: 14,
                                          color: MyColors.TEXT_SE),
                                )),
                          ));
                    });
              });
        });
  }
}
