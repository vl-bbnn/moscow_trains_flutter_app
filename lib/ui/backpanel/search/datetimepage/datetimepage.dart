import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/search/datetimepage/arrivalswitcher/arrivalswitcher.dart';
import 'package:trains/ui/backpanel/search/datetimepage/dateslist/dateslist.dart';
import 'package:trains/ui/backpanel/search/datetimepage/timeslider/timeselector.dart';

class DateTimePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          child: Material(
            color: Constants.BACKGROUND_GREY_1DP,
            elevation: 1.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: ArrivalSwitcher(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: DatesList(),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: TimeSelector(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
