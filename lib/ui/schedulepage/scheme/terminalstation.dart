import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/ui/common/mycolors.dart';

class TerminalStation extends StatelessWidget {
  final Status status;
  final double roadValue;
  final bool selected;
  final Station station;
  final Sizes sizes;
  final QueryType type;

  const TerminalStation(
      {this.sizes,
      this.roadValue,
      this.selected,
      this.station,
      this.type,
      this.status});

  _alignment() {
    switch (type) {
      case QueryType.departure:
        return TextAlign.end;
      case QueryType.arrival:
        return TextAlign.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalBloc.of(context);

    final align = _alignment();

    final height = sizes.scheme.textWidth;
    final width = sizes.scheme.textHeight;

    return status == Status.found && !selected
        ? RotatedBox(
            quarterTurns: 3,
            child: Opacity(
              opacity: roadValue,
              child: Container(
                  width: width,
                  height: height,
                  child: AutoSizeText(
                    station.title,
                    textAlign: align,
                    maxLines: 1,
                    minFontSize: 2,
                    group: globalBloc.textBloc.terminalStations,
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 14, color: MyColors.TEXT_SE),
                  )),
            ))
        : SizedBox();
  }
}
