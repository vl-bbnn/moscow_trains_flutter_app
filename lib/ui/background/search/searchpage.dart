import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/blocs/navbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/background/search/dateselector.dart';
import 'package:trains/ui/background/search/timeselector.dart';
import 'package:trains/ui/res/stationcard.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final searchBloc = InheritedBloc.searchOf(context);
    final persistentBloc = InheritedBloc.persistentOf(context);
    final stationTypeBloc = InheritedBloc.stationTypeOf(context);
    final timeBloc = InheritedBloc.timeOf(context);
    final dateBloc = InheritedBloc.dateOf(context);
    final reqTypeBloc = InheritedBloc.reqTypeBloc;
    final navBloc = InheritedBloc.navOf(context);
    final cornerRadius = 25.0;
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
                SizedBox(height: MediaQuery.of(context).padding.top),
                Container(
                  height: 140,
                  child: Center(
                    child: DateSelector(
                      size: MediaQuery.of(context).size.width,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal:Constants.PADDING_BIG),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            stationTypeBloc.type.add(Input.departure);
                            navBloc.state.add(NavState.Station);
                          },
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(cornerRadius))),
                            color: Constants.BACKGROUND,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
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
                        Container(
                          width: Constants.STATIONCARD_WIDTH + 30,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                child: Icon(
                                  Icons.arrow_downward,
                                  size: 36,
                                  color: Constants.GREY,
                                ),
                                behavior: HitTestBehavior.translucent,
                                onTap: () {
                                  searchBloc.switchInputs();
                                  persistentBloc.switchStations();
                                },
                              ),
                              StreamBuilder<Input>(
                                  stream: reqTypeBloc.type,
                                  builder: (context, snapshot) {
                                    switch (snapshot.data) {
                                      case Input.departure:
                                        return GestureDetector(
                                          onTap: () {
                                            reqTypeBloc.switchTypes();
                                          },
                                          child: Center(
                                            child: Text(
                                              "отправлением\nпосле",
                                              textAlign: TextAlign.end,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
                                            ),
                                          ),
                                        );
                                      case Input.arrival:
                                        return GestureDetector(
                                          onTap: () {
                                            reqTypeBloc.switchTypes();
                                          },
                                          child: Center(
                                            child: Text(
                                              "прибытием\nдо",
                                              textAlign: TextAlign.end,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .button,
                                            ),
                                          ),
                                        );
                                      default:
                                        return Container();
                                    }
                                  }),
                            ],
                          ),
                        ),
                        GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: () {
                            stationTypeBloc.type.add(Input.arrival);
                            navBloc.state.add(NavState.Station);
                          },
                          child: Material(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(cornerRadius))),
                            color: Constants.BACKGROUND,
                            child: Padding(
                              padding: const EdgeInsets.all(15),
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
                  height: 180,
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
