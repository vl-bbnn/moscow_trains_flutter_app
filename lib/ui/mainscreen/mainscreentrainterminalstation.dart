import 'package:flutter/material.dart';
import 'package:trains/ui/res/mycolors.dart';

class MainScreenTrainTerminalStation extends StatelessWidget {
  final station;

  const MainScreenTrainTerminalStation({Key key, this.station})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
        quarterTurns: 3,
        child: Text(
          station.toString(),
          style: Theme.of(context)
              .textTheme
              .headline2
              .copyWith(fontSize: 18, color: MyColors.SECONDARY_TEXT),
        ));
  }
}
