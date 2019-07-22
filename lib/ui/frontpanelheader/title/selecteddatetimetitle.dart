import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/blocs/uibloc.dart';
import 'package:trains/data/src/constants.dart';

class SelectedDateTimeTitle extends StatelessWidget {
  _dateText(DateTime date) {
    var now = DateTime.now();
    if (date.month == now.month && date.day == now.day)
      return "сегодня";
    else if (date.month == now.month && date.day - now.day == 1)
      return "завтра";
    else {
      return date.day.toString() + " " + _monthText(date);
    }
  }

  _monthText(DateTime date) {
    switch (date.month) {
      case 1:
        return "января";
      case 2:
        return "февраля";
      case 3:
        return "марта";
      case 4:
        return "апреля";
      case 5:
        return "мая";
      case 6:
        return "июня";
      case 7:
        return "июля";
      case 8:
        return "августа";
      case 9:
        return "сентября";
      case 10:
        return "октября";
      case 11:
        return "ноября";
      case 12:
        return "декабря";
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: StreamBuilder<Map<SearchParameter, Object>>(
          stream: trainsBloc.searchParametersStream,
          builder: (context, parameters) {
            if (!parameters.hasData) return Container();
            var arrival = parameters.data[SearchParameter.arrival] as bool;
            var dateTime =
                parameters.data[SearchParameter.dateTime] as DateTime;
            var arrivalText = "отправлением ";
            var dateText = "сегодня ";
            var arrivalPrefixText = "после ";
            var timeText = "сейчас";
            var text = "";
            if (arrival) {
              arrivalText = "прибытием ";
              arrivalPrefixText = "до ";
            }
            text += arrivalText;
            if (parameters.hasData) {
              dateText = _dateText(dateTime) + " ";
              timeText = DateFormat('kk:mm').format(dateTime);
              text += dateText + arrivalPrefixText + timeText;
            } else
              text += timeText;
            return Text(
              text,
              style: TextStyle(
                  fontSize: Constants.TEXT_SIZE_MEDIUM,
                  fontWeight: FontWeight.bold,
                  color: Constants.whiteMedium),
            );
          }),
    );
  }
}
