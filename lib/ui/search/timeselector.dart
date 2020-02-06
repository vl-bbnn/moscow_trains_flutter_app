import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/res/time.dart';
import 'package:trains/ui/stationselect/inputselector.dart';

class TimeSelector extends StatelessWidget {
  _getHeight(context) {
    // print("Search Panel size update");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final renderBox = (context.findRenderObject() as RenderBox);
      // print("Time Selector Height: " + renderBox.size.height.toString());
    });
  }

  _setTimeSelectorWidth(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = (context.findRenderObject() as RenderBox);
      InheritedBloc.dateTimeBloc.timeWidth.add(renderBox.size.width - 40);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeBloc = InheritedBloc.dateTimeBloc;
    _getHeight(context);
    _setTimeSelectorWidth(context);

    return Container(
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(color: Constants.ELEVATED_2, width: 3))),
      padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 12),
      child: Column(
        children: <Widget>[
          InputSelector(
            inputType: InputType.Time,
          ),
          SizedBox(
            height: 15,
          ),
          StreamBuilder<double>(
              stream: dateTimeBloc.timePercent,
              builder: (context, snapshot) {
                var percent = snapshot.data;
                if (!snapshot.hasData) percent = 0;
                final left = percent * (dateTimeBloc.timeWidth.value - 110);
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTapDown: (details) {
                    // print("Tap Down");
                    dateTimeBloc.dateChangesByTime.add(true);
                    dateTimeBloc.shouldUpdateTime.add(false);
                    final newOffset = details.localPosition.dx;
                    dateTimeBloc.selectTime(newOffset);
                  },
                  onTapUp: (_) {
                    print("Tap Up");
                    InheritedBloc.trainsBloc.trim();
                  },
                  onHorizontalDragDown: (_) {
                    // print("Drag Down");
                    dateTimeBloc.dateChangesByTime.add(true);
                    dateTimeBloc.shouldUpdateTime.add(false);
                  },
                  onHorizontalDragUpdate: (details) {
                    final newOffset = details.localPosition.dx;
                    dateTimeBloc.selectTime(newOffset);
                  },
                  onHorizontalDragEnd: (_) {
                    print("Drag End");
                    InheritedBloc.trainsBloc.trim();
                  },
                  child: Container(
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                                color: Constants.ELEVATED_3, width: 2))),
                    padding: const EdgeInsets.all(3),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(5),
                          child: SizedBox(
                            width: 275,
                            height: 30,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children:
                                  List.generate(7, (index) => (index * 4) % 24)
                                      .map((hour) => HourMark(
                                            hour: hour,
                                          ))
                                      .toList(),
                            ),
                          ),
                        ),
                        Positioned(
                          left: left,
                          width: 100,
                          height: 40,
                          child: StreamBuilder<DateTime>(
                              stream: InheritedBloc.searchBloc.dateTime,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) return Container();
                                return GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: () {
                                    dateTimeBloc.resetTime();
                                    InheritedBloc.trainsBloc.trim();
                                  },
                                  child: Material(
                                    elevation: 4,
                                    color: Constants.ELEVATED_3,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                    child: Center(
                                      child: Time(
                                        align: TextAlign.center,
                                        time: snapshot.data,
                                        small: true,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ],
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }
}

class HourMark extends StatelessWidget {
  final int hour;

  const HourMark({Key key, @required this.hour}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.TIMECARD_WIDTH,
      height: Constants.TIMECARD_HEIGHT,
      child: Center(
        child: Text(
          hour < 10 ? "0" + hour.toString() : hour.toString(),
          style: TextStyle(
            color: Constants.GREY,
            fontFeatures: [FontFeature.enable('ss03')],
            fontFamily: "Moscow Sans",
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
