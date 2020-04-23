import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/mysizes.dart';

class TerminalStation extends StatefulWidget {
  final Status status;
  final double value;
  final QueryType type;
  final bool trainTerminal;
  final String text;

  const TerminalStation(
      {this.text: "",
      this.value: 0.0,
      this.status: Status.notFound,
      this.type: QueryType.departure,
      this.trainTerminal: true});

  @override
  _TerminalStationState createState() => _TerminalStationState();
}

class _TerminalStationState extends State<TerminalStation> {
  double fullHeight;
  double fullWidth;
  TextAlign align;

  update() {
    final size = MediaQuery.of(context).size;
    align = alignment();
    fullWidth = Helper.height(SchemeSizes.TEXT_WIDTH, size);
    fullHeight = Helper.width(SchemeSizes.TEXT_HEIGHT, size);
  }

  alignment() {
    switch (widget.type) {
      case QueryType.departure:
        return TextAlign.end;
      case QueryType.arrival:
        return TextAlign.start;
    }
  }

  @override
  Widget build(BuildContext context) {
    update();
    final textBloc = GlobalValues.of(context).textBloc;
    final width = widget.value * fullWidth;
    final height = widget.value * fullHeight;
    return widget.status == Status.found && !widget.trainTerminal
        ? RotatedBox(
            quarterTurns: 3,
            child: Opacity(
              opacity: widget.value,
              child: Container(
                  width: width,
                  height: height,
                  child: AutoSizeText(
                    widget.text,
                    textAlign: align,
                    maxLines: 1,
                    minFontSize: 2,
                    group: textBloc.terminalStations,
                    style: Theme.of(context)
                        .textTheme
                        .headline2
                        .copyWith(fontSize: 14, color: MyColors.TEXT_SE),
                  )),
            ))
        : SizedBox();
  }
}
