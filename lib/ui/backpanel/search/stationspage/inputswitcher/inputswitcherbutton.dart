import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';

class InputSwitcherButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    final stationsBloc = InheritedBloc.stationsOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        trainsBloc.switchInputs();
        stationsBloc.switchInputType();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Icon(
          Icons.swap_horiz,
          color: Constants.accentColor,
          size: Constants.TEXT_SIZE_MAX,
        ),
      ),
    );
  }
}
