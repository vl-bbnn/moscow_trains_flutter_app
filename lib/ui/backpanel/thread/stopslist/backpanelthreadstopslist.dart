import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/suggestion.dart';
import 'package:trains/data/classes/thread.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/thread/stopslist/backpanelstop.dart';

class BackPanelThreadStopsList extends StatefulWidget {
  final Thread thread;
  final Sink<int> stopsLeft;
  final Sink<int> minutesLeft;

  const BackPanelThreadStopsList(
      {Key key,
      @required this.thread,
      @required this.stopsLeft,
      @required this.minutesLeft})
      : super(key: key);

  @override
  _BackPanelThreadStopsListState createState() =>
      _BackPanelThreadStopsListState();
}

class _BackPanelThreadStopsListState extends State<BackPanelThreadStopsList> {
  final stopHeight = 35.0;
  var pastHeight = 0.0;
  var pastIndex = 0;
  String fromCode;
  String toCode;
  ScrollController scrollController;
  Timer once;
  Timer periodic;

  void _timer() {
    final seconds = 60 - DateTime.now().second;
    once = Timer(Duration(seconds: seconds), () {
      setState(() {});
      periodic = Timer.periodic(Duration(minutes: 1), (Timer t) {
        setState(() {});
      });
    });
  }

  _percentUpdate() {
    final now = DateTime.now();
    if (widget.thread.endDateTime.isBefore(now)) {
      pastIndex = widget.thread.stopsCount - 1;
      if (pastHeight == 0.0) pastHeight = pastIndex * stopHeight;
    } else if (widget.thread.startDateTime.isBefore(now)) {
      for (int i = pastIndex + 1; i < widget.thread.stops.length; i++) {
        final stop = widget.thread.stops.elementAt(i);
        if (stop.departure != null && stop.departure.isAfter(now)) {
          final prevStop = widget.thread.stops.elementAt(i - 1);
          final percent = (((now.millisecondsSinceEpoch -
                              prevStop.arrival.millisecondsSinceEpoch) /
                          (stop.arrival.millisecondsSinceEpoch -
                              prevStop.arrival.millisecondsSinceEpoch)) /
                      0.2)
                  .floor() *
              0.2;
          pastIndex = i - 1;
          pastHeight = (pastIndex + percent) * stopHeight;
          break;
        }
      }
    }
    _updateStationsLeft();
  }

  _updateStationsLeft() {
    if (fromCode != null && toCode != null) {
      var fromIndex = 0;
      var toIndex = 0;
      DateTime fromDateTime;
      DateTime toDateTime;
      widget.thread.stops.asMap().forEach((index, stop) {
        if (stop.suggestion.station.code == fromCode) {
          fromIndex = index;
          fromDateTime = stop.departure;
        } else if (stop.suggestion.station.code == toCode) {
          toIndex = index;
          toDateTime = stop.arrival;
        }
      });
      final now = DateTime.now();
      if (fromDateTime != null && toDateTime != null) {
        final maxDateTime = fromDateTime.isAfter(now) ? fromDateTime : now;
        final minutes = toDateTime.difference(maxDateTime).inMinutes;
        widget.minutesLeft.add(minutes);
      }
      widget.stopsLeft.add(toIndex - max(pastIndex, fromIndex));
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    _percentUpdate();
    return StreamBuilder<Map<SearchParameter, Object>>(
        stream: trainsBloc.searchParametersStream,
        builder: (context, snapshot) {
          fromCode = snapshot.hasData
              ? (snapshot.data[SearchParameter.from] as Station).station.code
              : null;
          toCode = snapshot.hasData
              ? (snapshot.data[SearchParameter.to] as Station).station.code
              : null;
          _updateStationsLeft();
          return ListView(
            controller: scrollController,
            children: <Widget>[
              Container(
                height: 160.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Stack(
                  children: <Widget>[
                    Positioned(
                      left: 13.0,
                      top: stopHeight / 2,
                      bottom: stopHeight / 2,
                      child: Column(
                        children: <Widget>[
                          Container(
                            width: 4.0,
                            height: pastHeight,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                                color: Constants.accentColor),
                          ),
                          Container(
                            width: 2.0,
                            height:
                                stopHeight * (widget.thread.stops.length - 1) -
                                    pastHeight,
                            color: Constants.whiteDisabled,
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: widget.thread.stops.map((stop) {
                        final selected = snapshot.hasData
                            ? stop.suggestion.station.code == fromCode ||
                                stop.suggestion.station.code == toCode
                            : false;
                        return Container(
                          height: stopHeight,
                          child: BackPanelStop(
                            stop: stop,
                            selected: selected,
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              Container(
                height: 22.0,
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    _percentUpdate();
    scrollController =
        new ScrollController(initialScrollOffset: pastIndex * stopHeight);
//    if (widget.thread.startDateTime.isBefore(DateTime.now()))
    _timer();
  }

  @override
  void dispose() {
    if (once != null) once.cancel();
    if (periodic != null) periodic.cancel();
    super.dispose();
  }
}
