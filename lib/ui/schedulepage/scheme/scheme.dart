import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mysizes.dart';
import 'package:trains/ui/schedulepage/scheme/deselectedroad.dart';
import 'package:trains/ui/schedulepage/scheme/selectedroad.dart';
import 'package:trains/ui/schedulepage/scheme/stationicon.dart';
import 'package:trains/ui/schedulepage/scheme/terminalstation.dart';

class Scheme extends StatelessWidget {
  final status;

  const Scheme({this.status});

  _isTerminal(station) {
    if (station == null) return false;
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
    final height = size.height;
    final padding = MediaQuery.of(context).padding;

    final departureFullHeight = padding.top +
        Helper.height(
            MainScreenSizes.TOP_PADDING + StationSizes.STATION_HEIGHT / 2,
            size);
    final arrivalFullHeight = padding.bottom +
        Helper.height(
            MainScreenSizes.BOTTOM_PADDING +
                NavPanelSizes.PANEL_HEIGHT +
                NavPanelSizes.BOTTOM_PADDING +
                StationSizes.STATION_HEIGHT / 2,
            size);
    final iconFullSize = Helper.height(SchemeSizes.LINE_WIDTH * 2, size);

    final collapseToValue = 0.5;
    final departureHeightPercent = (departureFullHeight / height);
    final arrivalHeightPercent = (arrivalFullHeight / height);
    final selectedHeightPercent =
        (1 - departureHeightPercent - arrivalHeightPercent);
    final iconFullSizePercent = iconFullSize / height;

    return StreamBuilder<Map>(
        stream: GlobalValues.of(context).scheduleBloc.map,
        builder: (context, mapStream) {
          if (!mapStream.hasData) return Container();

          final map = mapStream.data;
          final fromStation = map['fromStation'];
          final toStation = map['toStation'];
          final fromTerminal = _isTerminal(fromStation);
          final toTerminal = _isTerminal(toStation);

          final curvedValue = map['curvedValue'] as double ?? 0.0;
          final found = status == Status.found;

          final currentDeparture = map['currentDeparture'] ?? "";
          final currentArrival = map['currentArrival'] ?? "";
          final currentTrainClass = map['currentTrainClass'];
          var currentDepartureSelected =
              map['currentDepartureSelected'] ?? fromTerminal;
          var currentArrivalSelected =
              map['currentArrivalSelected'] ?? toTerminal;
          if (!found) {
            currentDepartureSelected = fromTerminal;
            currentArrivalSelected = toTerminal;
          }
          final nextDeparture = map['nextDeparture'] ?? "";
          final nextArrival = map['nextArrival'] ?? "";
          final nextTrainClass = map['nextTrainClass'];
          var nextDepartureSelected =
              map['nextDepartureSelected'] ?? fromTerminal;
          var nextArrivalSelected = map['nextArrivalSelected'] ?? toTerminal;

          var departureTerminal = true;
          var departureHasTransit = fromStation.transitList.isNotEmpty;
          var arrivalTerminal = true;
          var arrivalHasTransit = toStation.transitList.isNotEmpty;

          var departureValue = 0.0;
          var departureIconValue = 0.0;
          var arrivalValue = 0.0;
          var arrivalIconValue = 0.0;
          var selectedValue = 0.0;
          var trainClass = TrainClass.standart;

          var departureTitle = "";
          var arrivalTitle = "";

          final collapsingValue =
              curvedValue.clamp(0.0, collapseToValue) / collapseToValue;
          final expandValue = 1 - collapseToValue;
          final expandingValue =
              (curvedValue - collapseToValue).clamp(0.0, expandValue) /
                  expandValue;

          if (expandingValue > 0) {
            trainClass = nextTrainClass;

            if (!nextDepartureSelected) {
              departureValue =
                  (expandingValue.clamp(0.0, departureHeightPercent) /
                      departureHeightPercent);
              departureTitle = nextDeparture;
            }

            departureIconValue = ((expandingValue -
                        departureHeightPercent +
                        iconFullSizePercent / 2)
                    .clamp(0.0, iconFullSizePercent) /
                iconFullSizePercent);
            departureTerminal = nextDepartureSelected;

            selectedValue = ((expandingValue - departureHeightPercent)
                    .clamp(0.0, selectedHeightPercent) /
                selectedHeightPercent);

            arrivalIconValue = ((expandingValue -
                        departureHeightPercent -
                        selectedHeightPercent +
                        iconFullSizePercent / 2)
                    .clamp(0.0, iconFullSizePercent) /
                iconFullSizePercent);
            arrivalTerminal = nextArrivalSelected;

            if (!nextArrivalSelected) {
              arrivalValue = ((expandingValue -
                          selectedHeightPercent -
                          departureHeightPercent)
                      .clamp(0.0, arrivalHeightPercent) /
                  arrivalHeightPercent);
              arrivalTitle = nextArrival;
            }
          } else {
            trainClass = currentTrainClass;

            if (!currentArrivalSelected) {
              arrivalValue = 1 -
                  (collapsingValue.clamp(0.0, arrivalHeightPercent) /
                      arrivalHeightPercent);
              arrivalTitle = currentArrival;
            }

            arrivalIconValue = 1 -
                ((collapsingValue -
                            arrivalHeightPercent +
                            iconFullSizePercent / 2)
                        .clamp(0.0, iconFullSizePercent) /
                    iconFullSizePercent);
            arrivalTerminal = currentArrivalSelected;

            selectedValue = 1 -
                ((collapsingValue - arrivalHeightPercent)
                        .clamp(0.0, selectedHeightPercent) /
                    selectedHeightPercent);

            departureIconValue = 1 -
                ((collapsingValue -
                            arrivalHeightPercent -
                            selectedHeightPercent +
                            iconFullSizePercent / 2)
                        .clamp(0.0, iconFullSizePercent) /
                    iconFullSizePercent);
            departureTerminal = currentDepartureSelected;

            if (!currentDepartureSelected) {
              departureValue = 1 -
                  ((collapsingValue -
                              selectedHeightPercent -
                              arrivalHeightPercent)
                          .clamp(0.0, departureHeightPercent) /
                      departureHeightPercent);
              departureTitle = currentDeparture;
            }
          }

          // print("Collapsing Value: " + collapsingValue.toString());
          // print("Expanding Value: " + expandingValue.toString());
          // print("Departure Value: " + departureValue.toString());
          // print("Departure Icon Value: " + departureIconValue.toString());
          // print("Selected Value: " + selectedValue.toString());
          // print("Arrival Icon Value: " + arrivalIconValue.toString());
          // print("Arrival Value: " + arrivalValue.toString());
          // print("Train Class: " + trainClass.toString());
          // print("\n");

          return SizedBox(
            height: height,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: Helper.width(SchemeSizes.LEFT_PADDING, size),
                ),
                SizedBox(
                    width: Helper.width(SchemeSizes.TEXT_HEIGHT, size),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: Helper.height(
                                  SchemeSizes.TEXT_VERTICAL_PADDING, size) +
                              padding.top,
                          bottom: Helper.height(
                                  NavPanelSizes.OUTER_BOTTOM_PADDING +
                                      NavPanelSizes.PANEL_HEIGHT +
                                      SchemeSizes.TEXT_VERTICAL_PADDING,
                                  size) +
                              padding.bottom),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TerminalStation(
                            type: QueryType.departure,
                            status: status,
                            text: departureTitle,
                            trainTerminal: departureTerminal,
                            value: departureValue,
                          ),
                          TerminalStation(
                            type: QueryType.arrival,
                            status: status,
                            text: arrivalTitle,
                            trainTerminal: arrivalTerminal,
                            value: arrivalValue,
                          ),
                        ],
                      ),
                    )),
                Stack(
                  children: <Widget>[
                    SizedBox(
                      width: SchemeSizes.SCHEME_WIDTH,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: SchemeSizes.LINE_LEFT_PADDING,
                            right: SchemeSizes.LINE_RIGHT_PADDING),
                        child: Column(
                          children: <Widget>[
                            DeselectedRoad(
                              type: QueryType.departure,
                              status: status,
                              roadTerminal: fromTerminal,
                              trainClass: trainClass,
                              value: departureValue,
                            ),
                            SelectedRoad(
                              status: status,
                              trainClass: trainClass,
                              value: selectedValue,
                            ),
                            DeselectedRoad(
                              type: QueryType.arrival,
                              status: status,
                              roadTerminal: toTerminal,
                              trainClass: trainClass,
                              value: arrivalValue,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: departureFullHeight - SchemeSizes.LINE_WIDTH,
                      bottom: arrivalFullHeight - SchemeSizes.LINE_WIDTH,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StationIcon(
                            type: QueryType.departure,
                            status: status,
                            roadTerminal: fromTerminal,
                            trainTerminal: departureTerminal,
                            hasTransit: departureHasTransit,
                            trainClass: trainClass,
                            value: departureIconValue,
                          ),
                          StationIcon(
                            type: QueryType.arrival,
                            status: status,
                            roadTerminal: toTerminal,
                            trainTerminal: arrivalTerminal,
                            hasTransit: arrivalHasTransit,
                            trainClass: trainClass,
                            value: arrivalIconValue,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
  }
}
