import 'package:flutter/material.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/ui/schedulepage/scheme/deselectedroad.dart';
import 'package:trains/ui/schedulepage/scheme/selectedroad.dart';
import 'package:trains/ui/schedulepage/scheme/stationicon.dart';
import 'package:trains/ui/schedulepage/scheme/terminalstation.dart';

class Scheme extends StatelessWidget {
  final status;

  const Scheme({this.status});

  @override
  Widget build(BuildContext context) {
    final sizesBloc = GlobalBloc.of(context).sizesBloc;
    return StreamBuilder<Sizes>(
        stream: sizesBloc.outputSizes,
        builder: (context, sizesSnapshot) {
          if (!sizesSnapshot.hasData) return Container();
          final sizes = sizesSnapshot.data;
          return SizedBox(
            height: sizes.fullHeight,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: sizes.schemeLeftPadding,
                ),
                SizedBox(
                    width: sizes.schemeTextWidth,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: sizes.schemeTextVerticalPadding +
                              sizes.topPadding,
                          bottom: sizes.schemeTextVerticalPadding +
                              sizes.bottomPadding),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          TerminalStation(
                            type: QueryType.departure,
                            sizes: sizes,
                            status: status,
                          ),
                          TerminalStation(
                            type: QueryType.arrival,
                            sizes: sizes,
                            status: status,
                          ),
                        ],
                      ),
                    )),
                Stack(
                  children: <Widget>[
                    SizedBox(
                      width: sizes.schemeWidth,
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: sizes.schemeLineLeftPadding,
                            right: sizes.schemeLineRightPadding),
                        child: Column(
                          children: <Widget>[
                            DeselectedRoad(
                              type: QueryType.departure,
                              sizes: sizes,
                              status: status,
                            ),
                            SelectedRoad(
                              status: status,
                              sizes: sizes,
                            ),
                            DeselectedRoad(
                              type: QueryType.arrival,
                              sizes: sizes,
                              status: status,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      top: sizes.schemeDepartureHeight -
                          sizes.schemeIconSize / 2,
                      bottom: sizes.schemeleArrivalHeight -
                          sizes.schemeIconSize / 2,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          StationIcon(
                            type: QueryType.departure,
                            sizes: sizes,
                            status: status,
                          ),
                          StationIcon(
                            type: QueryType.arrival,
                            sizes: sizes,
                            status: status,
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
