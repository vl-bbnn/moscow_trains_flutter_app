import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class TravelTime extends StatelessWidget {
  final List<Train> sublist;

  const TravelTime({Key key, @required this.sublist}) : super(key: key);

  String _text() {
    var totalMinutes = 0;
    var text = "";
    sublist.forEach((train) {
      totalMinutes += train.departure.difference(train.arrival).inMinutes.abs();
    });
    var averageMinutes = (totalMinutes / sublist.length).floor();
    if (averageMinutes != 0) {
      text = "В пути в среднем " +
          Helper.minutesToText(averageMinutes).elementAt(4);
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    var text = _text();
    return text.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              text,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Constants.TEXT_SIZE_MEDIUM,
                  color: Constants.whiteMedium),
            ),
          )
        : Container();
  }
}
