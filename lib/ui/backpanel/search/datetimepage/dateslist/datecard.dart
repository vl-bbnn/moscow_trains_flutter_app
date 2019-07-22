import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/src/constants.dart';

class DateCard extends StatelessWidget {
  final DateTime dateTime;

  const DateCard({Key key, this.dateTime}) : super(key: key);

  String _weekday(int weekday) {
    switch (weekday) {
      case 1:
        {
          return "ПН";
        }
      case 2:
        {
          return "ВТ";
        }
      case 3:
        {
          return "СР";
        }
      case 4:
        {
          return "ЧТ";
        }
      case 5:
        {
          return "ПТ";
        }
      case 6:
        {
          return "СБ";
        }
      case 7:
        {
          return "ВС";
        }
    }
    return "Nn";
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    var now = DateTime.now();
    var color = Constants.whiteMedium;
    if (dateTime.weekday > 5) color = Constants.red;
    return StreamBuilder<Map<SearchParameter, Object>>(
        stream: trainsBloc.searchParametersStream,
        builder: (context, parameters) {
          if (!parameters.hasData) return Container();
          var selectedDate =
              parameters.data[SearchParameter.dateTime] as DateTime;
          bool selected = (dateTime.day == selectedDate.day &&
              dateTime.month == selectedDate.month);
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: GestureDetector(
              onTap: () {
                var isToday = dateTime.day == now.day &&
                    dateTime.month == now.month &&
                    dateTime.year == now.year;
                var newSelectedDate = DateTime(
                    dateTime.year,
                    dateTime.month,
                    dateTime.day,
                    isToday ? now.hour : selectedDate.hour,
                    isToday ? now.minute : selectedDate.minute);
                trainsBloc.updateSelectedDate(newSelectedDate);
              },
              child: Material(
                color: selected
                    ? Constants.BACKGROUND_GREY_1DP
                    : Constants.BACKGROUND_GREY_4DP,
                elevation: selected ? 0.0 : 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0),
                    side: selected
                        ? BorderSide(color: Constants.accentColor, width: 2.0)
                        : BorderSide(style: BorderStyle.none)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12.0, vertical: 4.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          dateTime.day.toString(),
                          style: TextStyle(
                              fontSize: selected
                                  ? Constants.TEXT_SIZE_BIG
                                  : Constants.TEXT_SIZE_BIG + 1,
                              fontWeight: FontWeight.bold,
                              color: selected ? Constants.accentColor : color),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: Text(
                          _weekday(dateTime.weekday),
                          style: TextStyle(
                              fontSize: selected
                                  ? Constants.TEXT_SIZE_MEDIUM
                                  : Constants.TEXT_SIZE_MEDIUM + 1,
                              fontWeight: FontWeight.w500,
                              color: selected ? Constants.accentColor : color),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
