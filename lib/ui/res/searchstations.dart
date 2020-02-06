import 'package:flutter/material.dart';
import 'package:trains/data/blocs/frontpanelbloc.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/res/stationcard.dart';

class SearchStations extends StatelessWidget {
  _updatePanelHeight(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderObject = context.findRenderObject();
      final renderBox = renderObject as RenderBox;
      InheritedBloc.frontPanelBloc.stationsPanelHeight
          .add(renderBox.size.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    final searchBloc = InheritedBloc.searchBloc;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              StreamBuilder<Station>(
                  stream: searchBloc.fromStation,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        height: Constants.STATIONCARD_HEIGHT,
                        color: Constants.ELEVATED_2,
                      );
                    _updatePanelHeight(context);
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        InheritedBloc.stationTypeBloc.type.add(Input.departure);
                        InheritedBloc.frontPanelBloc.state
                            .add(FrontPanelState.StationSelect);
                        InheritedBloc.frontPanelBloc.panelController.open();
                      },
                      child: StationCard(
                        station: snapshot.data,
                      ),
                    );
                  }),
              StreamBuilder<Station>(
                  stream: searchBloc.toStation,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData)
                      return Container(
                        height: Constants.STATIONCARD_HEIGHT,
                        color: Constants.ELEVATED_2,
                      );
                    _updatePanelHeight(context);
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        InheritedBloc.stationTypeBloc.type.add(Input.arrival);
                        InheritedBloc.frontPanelBloc.state
                            .add(FrontPanelState.StationSelect);
                        InheritedBloc.frontPanelBloc.panelController.open();
                      },
                      child: StationCard(
                        station: snapshot.data,
                        right: true,
                      ),
                    );
                  }),
            ],
          ),
          Positioned.fill(
            child: Center(
              child: GestureDetector(
                child: Container(
                  width: 54,
                  height: 54,
                  decoration: ShapeDecoration(
                      color: Constants.ELEVATED_2, shape: CircleBorder()),
                  child: Center(
                    child: Icon(
                      Icons.arrow_forward,
                      size: 24,
                      color: Constants.WHITE,
                    ),
                  ),
                ),
                onTap: () {
                  searchBloc.switchInputs();
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
