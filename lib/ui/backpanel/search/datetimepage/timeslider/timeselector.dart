import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/ui/backpanel/search/datetimepage/timeslider/waveslider.dart';

class TimeSelector extends StatefulWidget {
  @override
  _TimeSelectorState createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return StreamBuilder<Map<SearchParameter, Object>>(
        stream: trainsBloc.searchParametersStream,
        builder: (context, parameters) {
          if (!parameters.hasData) return Container();
          var dateTime = parameters.data[SearchParameter.dateTime] as DateTime;
          if (dateTime == null) return Container();
          return WaveSlider(
            initialDateTime: dateTime,
            onChangeEnd: (time) {
              var newDateTime = new DateTime(dateTime.year, dateTime.month,
                  dateTime.day, time.hour, time.minute);
              trainsBloc.updateSelectedDate(newDateTime);
            },
          );
        });
  }
}
