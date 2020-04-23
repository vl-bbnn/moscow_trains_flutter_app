import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/ui/common/mycolors.dart';

class Time extends StatelessWidget {
  final DateTime time;
  final bool warn;

  const Time({@required this.time, this.warn = false});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textBloc = GlobalValues.of(context).textBloc;
    return Container(
      color: textBloc.showTextBorders ? Colors.red : null,
      width: size.width * 0.25,
      child: AutoSizeText.rich(
        TextSpan(children: [
          TextSpan(
            text: time != null ? DateFormat("H").format(time) + ":" : "--:",
            style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 30,
                color: warn ? MyColors.WA_B70 : MyColors.TEXT_SE),
          ),
          TextSpan(
            text: time != null ? DateFormat("mm").format(time) : "--",
            style: Theme.of(context).textTheme.headline1.copyWith(
                fontSize: 30,
                color: warn ? MyColors.WA : MyColors.TEXT_PR),
          )
        ]),
        maxLines: 1,
        group: textBloc.time,
      ),
    );
  }
}
