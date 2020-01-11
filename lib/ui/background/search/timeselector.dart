import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';

class TimeSelector extends StatelessWidget {
  const TimeSelector({Key key, this.size}) : super(key: key);

  final double size;

  final width = Constants.TIMECARD_WIDTH;
  final height = Constants.TIMECARD_HEIGHT;

  @override
  Widget build(BuildContext context) {
    final timeBloc = InheritedBloc.timeOf(context);
    final listviewPadding =
        size / 2 - height * 1.5 - Constants.PADDING_REGULAR * 6;
    final listviewEndPadding =
        size / 2 - height * 1.5 - Constants.PADDING_REGULAR * 3;
    timeBloc.rebuilt();
    return Container(
      height: size,
      width: width * 1.5 + Constants.PADDING_REGULAR * 2,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
              width: width,
              child: StreamBuilder<List<int>>(
                  stream: timeBloc.list.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ListView.builder(
                        scrollDirection: Axis.vertical,
                        itemCount: snapshot.data.length,
                        physics: NeverScrollableScrollPhysics(),
                        controller: timeBloc.scroll,
                        itemBuilder: (context, index) {
                          final hour = snapshot.data.elementAt(index);
                          final first = index == 0;
                          final last = index == snapshot.data.length - 1;
                          if (first)
                            return Column(
                              children: <Widget>[
                                Container(
                                  height: listviewPadding,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(
                                      Constants.PADDING_REGULAR),
                                  child: TimeCardRegular(
                                    hour: 23,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(
                                      Constants.PADDING_REGULAR),
                                  child: TimeCardRegular(
                                    hour: hour,
                                  ),
                                ),
                              ],
                            );
                          else if (last)
                            return Column(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.all(
                                      Constants.PADDING_REGULAR),
                                  child: TimeCardRegular(
                                    hour: hour,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(
                                      Constants.PADDING_REGULAR),
                                  child: TimeCardRegular(
                                    hour: 1,
                                  ),
                                ),
                                Container(
                                  height: listviewEndPadding,
                                ),
                              ],
                            );
                          else
                            return Padding(
                              padding: const EdgeInsets.all(
                                  Constants.PADDING_REGULAR),
                              child: TimeCardRegular(
                                hour: hour,
                              ),
                            );
                        });
                  })),
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [
                    0,
                    0.25,
                    0.5,
                    0.75,
                    1
                  ],
                      colors: [
                    Constants.BLACK,
                    Colors.transparent,
                    Constants.BLACK,
                    Colors.transparent,
                    Constants.BLACK
                  ])),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              child: StreamBuilder<DateTime>(
                  stream: timeBloc.selected,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return TimeCardSelected(
                      time: snapshot.data,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}

class TimeCardSelected extends StatelessWidget {
  final DateTime time;

  const TimeCardSelected({Key key, @required this.time}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.TIMECARD_WIDTH * 1.1,
      height: Constants.TIMECARD_HEIGHT * 1.2,
      child: Center(
        child: Column(
          children: <Widget>[
            Text(
              DateFormat("H").format(time),
              style: TextStyle(
                color: Constants.WHITE,
                fontFamily: "LexendDeca",
                fontSize: 36,
              ),
            ),
            Text(
              DateFormat("mm").format(time),
              style: TextStyle(
                color: Constants.WHITE,
                fontFamily: "LexendDeca",
                fontSize: 30,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TimeCardRegular extends StatelessWidget {
  final int hour;

  const TimeCardRegular({Key key, @required this.hour}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.TIMECARD_WIDTH,
      height: Constants.TIMECARD_HEIGHT,
      child: Center(
        child: Text(
          hour < 10 ? "0" + hour.toString() : hour.toString(),
          style: TextStyle(
            color: Constants.DARKGREY,
            fontFamily: "LexendDeca",
            fontSize: 24,
          ),
        ),
      ),
    );
  }
}
