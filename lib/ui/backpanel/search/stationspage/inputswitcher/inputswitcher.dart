import 'package:flutter/material.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/search/stationspage/inputswitcher/inputbutton.dart';
import 'package:trains/ui/backpanel/search/stationspage/inputswitcher/inputswitcherbutton.dart';

class InputSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.all(8.0),
      child: Material(
        color: Constants.BACKGROUND_GREY_1DP,
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InputButton(
                type: InputType.from,
              ),
              InputSwitcherButton(),
              InputButton(
                type: InputType.to,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
