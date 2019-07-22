import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/classes/stop.dart';
import 'package:trains/data/classes/suggestion.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class BackPanelStop extends StatelessWidget {
  final Stop stop;
  final bool selected;

  const BackPanelStop({Key key, @required this.stop, @required this.selected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stationsBloc = InheritedBloc.stationsOf(context);
    final mainTime = stop.departure != null
        ? stop.departure.toLocal()
        : stop.arrival.toLocal();
    final past = mainTime.isBefore(DateTime.now());
    final now = DateTime.now();
    final current = (stop.arrival == null && stop.departure.isAfter(now)) ||
        (stop.departure == null && stop.arrival.isBefore(now)) ||
        (stop.arrival != null &&
            stop.departure != null &&
            stop.departure.isAfter(now) &&
            stop.arrival.isBefore(now));
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 30.0,
          child: Container(
            width: current ? 8.0 : 6.0,
            height: current ? 8.0 : 6.0,
            alignment: Alignment.center,
            decoration: !past
                ? ShapeDecoration(
                    shape: CircleBorder(),
                    color:
                        current ? Constants.accentColor : Constants.whiteHigh)
                : null,
          ),
        ),
        Container(
          width: 80.0,
          padding: const EdgeInsets.all(8.0),
          child: Text(
            DateFormat("kk:mm").format(mainTime),
            textAlign: TextAlign.center,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: Constants.TEXT_SIZE_MEDIUM,
                color: past
                    ? Constants.whiteDisabled
                    : selected
                        ? Constants.accentColor
                        : current
                            ? Constants.whiteHigh
                            : Constants.whiteMedium),
          ),
        ),
        Expanded(
            child: StreamBuilder<Suggestion>(
                stream: stationsBloc.closestSuggestionStream,
                builder: (context, snapshot) {
                  final closest = snapshot.hasData
                      ? snapshot.data.station.code ==
                          stop.suggestion.station.code
                      : false;
                  return Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          stop.suggestion.station.name,
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontWeight: selected || current
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                              fontSize: Constants.TEXT_SIZE_MEDIUM,
                              color: past
                                  ? Constants.whiteDisabled
                                  : selected
                                      ? Constants.accentColor
                                      : current
                                          ? Constants.whiteHigh
                                          : Constants.whiteMedium),
                        ),
                      ),
                      closest
                          ? Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Icon(
                                Helper.suggestionIconData(Label.closest),
                                color: Constants.accentColor,
                                size: Constants.TEXT_SIZE_MEDIUM,
                              ),
                            )
                          : Container()
                    ],
                  );
                })),
      ],
    );
  }
}
