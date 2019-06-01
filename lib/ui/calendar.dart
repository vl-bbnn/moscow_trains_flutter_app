import 'package:flutter/material.dart';
import 'package:trains/data/Inheritedbloc.dart';
import 'package:trains/data/bloc.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  List<DateTime> _dates = [];
  DateTime now;
  DateTime selected;
  int start;
  TrainsBloc trainsBloc;

  @override
  void initState() {
    now = DateTime.now();
    selected = DateTime.now();
    start = DateTime(now.year, now.month, 1).weekday;
    super.initState();
  }

  _select(index) {
    var newDate = DateTime(now.year, now.month, index - start + 2);
    trainsBloc.selectedDateSink.add(newDate);
    setState(() {
      selected = newDate;
    });
  }

  _generate() {
    _dates.clear();
    var daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    for (int i = start - 1; i > 0; i--) {
      _dates.add(DateTime(now.year, now.month, -i + 1));
    }
    _dates.addAll(List.generate(
        daysInMonth, (index) => DateTime(now.year, now.month, index + 1)));
  }

  Widget _date(index) {
    var color = Colors.transparent;
    DateTime date = _dates.elementAt(index);
    if (date.month == selected.month && date.day == selected.day)
      color = Colors.greenAccent[100];
    var textColor = Colors.black;
    if (date.weekday > 5) textColor = Colors.red;
    return date.month == now.month
        ? GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              if (date.day >= now.day) _select(index);
            },
            child: Center(
              child: Opacity(
                opacity: date.day < now.day ? 0.4 : 1.0,
                child: Material(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      date.day.toString(),
                      style: TextStyle(
                          fontSize: date.day == selected.day ? 20.0 : 16.0,
                          fontWeight: date.day == selected.day
                              ? FontWeight.w700
                              : FontWeight.w500,
                          color: textColor),
                    ),
                  ),
                ),
              ),
            ),
          )
        : Container();
  }

  Widget _titles() {
    List<String> _weekDays = ['ПН', 'ВТ', 'СР', 'ЧТ', 'ПТ', 'СБ', 'ВС'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: _weekDays.map((title) {
        var color = Colors.black87;
        if (title == 'СБ' || title == 'ВС') color = Colors.red;
        return Container(
          padding: EdgeInsets.all(12.0),
          child: Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w500, fontSize: 14.0, color: color),
          ),
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    _generate();
    if (trainsBloc == null) trainsBloc = InheritedBloc.of(context);
    return Container(
      padding: EdgeInsets.all(18.0),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              trainsBloc.monthsNames.elementAt(now.month - 1),
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w700),
            ),
          ),
          _titles(),
          Expanded(
            child: GridView.builder(
              addRepaintBoundaries: true,
              itemCount: _dates.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 7),
              itemBuilder: (context, index) {
                return _date(index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
