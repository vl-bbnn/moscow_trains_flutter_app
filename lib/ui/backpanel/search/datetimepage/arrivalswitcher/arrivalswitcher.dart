import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/search/datetimepage/arrivalswitcher/arrivalbutton.dart';

class ArrivalSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Constants.BACKGROUND_GREY_1DP,
      elevation: 0.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ArrivalButton(
              type: ArrivalButtonType.departure,
            ),
            ArrivalButton(
              type: ArrivalButtonType.arrival,
            ),
          ],
        ),
      ),
    );
  }
}
