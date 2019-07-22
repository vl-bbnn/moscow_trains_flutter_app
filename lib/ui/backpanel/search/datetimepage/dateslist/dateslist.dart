import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/search/datetimepage/dateslist/datecard.dart';

class DatesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final count = 20;
    var now = DateTime.now();
    return Container(
      height: Constants.DATECARD_SIZE,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: count,
        itemBuilder: (context, index) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: index == 0 ? Constants.DATECARD_PADDING : 0.0,
              ),
              DateCard(dateTime: now.add(new Duration(days: index))),
              Container(
                width: index == count - 1 ? Constants.DATECARD_PADDING : 0.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
