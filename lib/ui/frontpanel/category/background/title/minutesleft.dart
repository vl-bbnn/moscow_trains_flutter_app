import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class MinutesLeft extends StatelessWidget {
  final List<Train> sublist;

  const MinutesLeft({Key key, @required this.sublist}) : super(key: key);

  String _text(DateTime dateTime, bool arrival) {
    bool customDateTime = dateTime.difference(DateTime.now()).inMinutes > 5;
    var after = "Через";
    if (arrival)
      after = "Раньше на";
    else if (customDateTime) after = "Позже на";
    List<int> _minutesLeftList = new List();
    sublist.forEach((train) {
      var time = train.departure;
      if (arrival) time = train.arrival;
      if ((arrival && time.difference(dateTime).isNegative) ||
          (!arrival && !time.difference(dateTime).isNegative)) {
        final minutes = time.difference(dateTime).inMinutes.abs();
        if ((minutes < 60) ||
            (_minutesLeftList.length == 0 && minutes < 4 * 60))
          _minutesLeftList.add(minutes);
      }
    });
    var text = "";
    if (_minutesLeftList.length > 0) {
      if (_minutesLeftList.elementAt(0) == 0) {
        text = customDateTime ? "Вовремя" : "Сейчас";
        if (_minutesLeftList.length > 1) {
          text +=
              " и ${after.toLowerCase()} ${Helper.minutesToText(_minutesLeftList.elementAt(1)).last}";
        }
      } else {
        if (_minutesLeftList.length > 1) {
          text +=
              "$after ${_minutesLeftList.elementAt(0).toString()} и ${Helper.minutesToText(_minutesLeftList.elementAt(1)).last}";
        } else {
          text +=
              "$after ${Helper.minutesToText(_minutesLeftList.elementAt(0)).last}";
        }
      }
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return StreamBuilder<Map<SearchParameter, Object>>(
      stream: trainsBloc.searchParametersStream,
      builder: (context, parameters) {
        if (!parameters.hasData) return Container();
        var dateTime = parameters.data[SearchParameter.dateTime] as DateTime;
        var arrival = parameters.data[SearchParameter.arrival] as bool;
        var text = _text(dateTime, arrival);
        return text.isNotEmpty
            ? Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  text,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: Constants.TEXT_SIZE_MEDIUM,
                      color: Constants.whiteMedium),
                ),
              )
            : Container();
      },
    );
  }
}
