import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/newData/blocs/datetimebloc.dart';
import 'package:trains/newData/blocs/inheritedbloc.dart';
import 'package:trains/newData/blocs/inputtypebloc.dart';
import 'package:trains/newData/blocs/navbloc.dart';
import 'package:trains/newData/classes/station.dart';
import 'package:trains/newUI/dateselector.dart';
import 'package:trains/newUI/stationcard.dart';
import 'package:trains/newUI/timeselector.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchBloc = InheritedBloc.searchOf(context);
    final persistentBloc = InheritedBloc.persistentOf(context);
    final stationTypeBloc = InheritedBloc.stationTypeOf(context);
    final timeBloc = InheritedBloc.timeOf(context);
    final dateBloc = InheritedBloc.dateOf(context);
    final navBloc = InheritedBloc.navOf(context);
    final cornerRadius = 35.5;
    var verticalStartPosition = 0.0;
    var verticalInitialOffset = 0.0;
    var horizontalStartPosition = 0.0;
    var horizontalInitialOffset = 0.0;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onVerticalDragDown: (details) {
        verticalStartPosition = details.localPosition.dy;
        verticalInitialOffset = timeBloc.scroll.offset;
        timeBloc.timerShouldUpdate.add(false);
      },
      onVerticalDragUpdate: (details) {
        final newOffset = verticalInitialOffset +
            (verticalStartPosition - details.localPosition.dy) * 2;
        timeBloc.jumpToOffset(newOffset);
      },
      onVerticalDragEnd: (details) {
        timeBloc.round();
      },
      onHorizontalDragDown: (details) {
        horizontalStartPosition = details.localPosition.dx;
        horizontalInitialOffset = dateBloc.scroll.offset;
        dateBloc.timerShouldUpdate.add(false);
      },
      onHorizontalDragUpdate: (details) {
        final newOffset = horizontalInitialOffset +
            (horizontalStartPosition - details.localPosition.dx) * 2;
        dateBloc.jumpToOffset(newOffset);
      },
      onHorizontalDragEnd: (details) {
        dateBloc.round();
      },
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  height: 20,
                ),
                Container(
                  height: 90,
                  child: Center(
                    child: DateSelector(
                      size: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 350,
                    padding: const EdgeInsets.all(Constants.PADDING_BIG),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            stationTypeBloc.type.add(Input.departure);
                            navBloc.state.add(NavState.Station);
                          },
                          child: Center(
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 3,
                                      color: Constants.PRIMARY,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(cornerRadius))),
                              color: Constants.BLACK,
                              child: StreamBuilder<Station>(
                                  stream: searchBloc.fromStation,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    return StationCard(
                                      station: snapshot.data,
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Align(
                          child: GestureDetector(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: Constants.PADDING_PAGE,
                                  horizontal: Constants.PADDING_MEDIUM),
                              child: Icon(
                                Icons.arrow_downward,
                                size: 36,
                                color: Constants.GREY,
                              ),
                            ),
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              searchBloc.switchInputs();
                              persistentBloc.switchStations();
                            },
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            stationTypeBloc.type.add(Input.arrival);
                            navBloc.state.add(NavState.Station);
                          },
                          child: Center(
                            child: Material(
                              shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                      width: 3,
                                      color: Constants.PRIMARY,
                                      style: BorderStyle.solid),
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(cornerRadius))),
                              color: Constants.BLACK,
                              child: StreamBuilder<Station>(
                                  stream: searchBloc.toStation,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container();
                                    }
                                    return StationCard(
                                      station: snapshot.data,
                                    );
                                  }),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 130,
                )
              ],
            ),
          ),
          TimeSelector(
            size: 520,
          ),
        ],
      ),
    );
  }
}
