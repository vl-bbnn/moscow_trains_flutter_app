import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/mainscreen/mainscreenstationicon.dart';
import 'package:trains/ui/mainscreen/mainscreentrainterminalstation.dart';
import 'package:trains/ui/res/mycolors.dart';

class MainScreenScheme extends StatelessWidget {
  _terminalStations(station) {
    switch (station.code) {
      case "s2006004":
      case "s9603093":
        return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final globalValues = GlobalValues.of(context);
    return StreamBuilder<Map>(
        stream: globalValues.schemeBloc.map,
        builder: (context, mapStream) {
          if (!mapStream.hasData) return Container();
          final map = mapStream.data;

          final status = map['status'] ?? Status.notFound;
          final notFound = status == Status.notFound;

          final trainOriginStation = map['trainOriginStation'];
          final trainDestinationStation = map['trainDestinationStation'];
          final fromStation = map['fromStation'] ?? "Не указана";
          final toStation = map['toStation'] ?? "Не указана";
          var selectedOrigin = map['selectedOrigin'] as bool ?? true;
          var selectedDestination = map['selectedDestination'] as bool ?? true;

          final bottomOffset = map['bottomOffset'] as double ?? 0.0;
          final topOffset = map['topOffset'] as double ?? 0.0;
          final departureTopOffset = map['departureTopOffset'] != null
              ? (map['departureTopOffset'] as double) - topOffset
              : 0.0;
          final arrivalBottomOffset = map['arrivalBottomOffset'] != null
              ? (map['arrivalBottomOffset'] as double) - bottomOffset
              : 0.0;
          final topOfTrainDetails = map['topOfTrainDetails'] != null
              ? (map['topOfTrainDetails'] as double) - topOffset
              : 0.0;
          final bottomOfTrainDetails = map['bottomOfTrainDetails'] != null
              ? (map['bottomOfTrainDetails'] as double) - bottomOffset
              : 0.0;
          final detailsOffset = Helper.height(10, size);
          final departureLineToDetails =
              max(0, topOfTrainDetails - departureTopOffset - detailsOffset)
                  .toDouble();
          final arrivalLineFromDetails =
              max(0, bottomOfTrainDetails - arrivalBottomOffset - detailsOffset)
                  .toDouble();
          if (notFound) {
            selectedOrigin = _terminalStations(fromStation);
            selectedDestination = _terminalStations(toStation);
          }
          return Row(
            children: <Widget>[
              SizedBox(
                width: Helper.width(10, size),
              ),
              SizedBox(
                width: Helper.width(30, size),
                child: !notFound
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: Helper.height(40, size)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            (!selectedOrigin)
                                ? MainScreenTrainTerminalStation(
                                    station: trainOriginStation,
                                  )
                                : Container(),
                            (!selectedDestination)
                                ? MainScreenTrainTerminalStation(
                                    station: trainDestinationStation,
                                  )
                                : Container(),
                          ],
                        ),
                      )
                    : Container(),
              ),
              Stack(
                children: <Widget>[
                  SizedBox(
                    width: 36,
                    height: size.height,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height:
                                !selectedOrigin ? departureTopOffset + 10 : 0,
                            color: notFound
                                ? MyColors.WARNING_04
                                : MyColors.LENINGRAD_04,
                            width: 12,
                          ),
                          AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            height: !selectedDestination
                                ? arrivalBottomOffset + 10
                                : 0,
                            color: notFound
                                ? MyColors.WARNING_04
                                : MyColors.LENINGRAD_04,
                            width: 12,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: departureTopOffset,
                    bottom: arrivalBottomOffset,
                    left: 12,
                    child: Column(
                      children: <Widget>[
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: ShapeDecoration(
                              color: notFound
                                  ? MyColors.WARNING_07
                                  : MyColors.LENINGRAD_07,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          width: 12,
                          height: departureLineToDetails,
                        ),
                        Expanded(
                          child: GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () {
                              globalValues.searchBloc.switchInputs();
                            },
                            child: Center(
                              child: SizedBox(
                                width: 12,
                                height: 28,
                                child: SvgPicture.asset(
                                  'assets/icons/direction.svg',
                                  semanticsLabel: 'standart',
                                  color: notFound
                                      ? MyColors.WARNING
                                      : MyColors.LENINGRAD,
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          decoration: ShapeDecoration(
                              color: notFound
                                  ? MyColors.WARNING_07
                                  : MyColors.LENINGRAD_07,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(6))),
                          width: 12,
                          height: arrivalLineFromDetails,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: departureTopOffset - 12,
                    bottom: arrivalBottomOffset - 12,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        MainScreenStationIcon(
                          notFound: notFound,
                          station: fromStation,
                          selected: selectedOrigin,
                          type: QueryType.departure,
                        ),
                        MainScreenStationIcon(
                          notFound: notFound,
                          station: toStation,
                          selected: selectedDestination,
                          type: QueryType.arrival,
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }
}
