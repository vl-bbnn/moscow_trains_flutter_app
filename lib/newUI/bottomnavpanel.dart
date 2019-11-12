import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/newData/blocs/inheritedbloc.dart';
import 'package:trains/newData/blocs/inputtypebloc.dart';
import 'package:trains/newData/blocs/navbloc.dart';
import 'package:trains/newData/blocs/trainsbloc.dart';
import 'package:trains/newData/classes/trainclass.dart';
import 'package:trains/newUI/squirclebutton.dart';
import 'package:trains/newUI/trainsclasscard.dart';

class BottomNavPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navBloc = InheritedBloc.navOf(context);
    final searchBloc = InheritedBloc.searchOf(context);
    final resultsBloc = InheritedBloc.trainsOf(context);
    final timeBloc = InheritedBloc.timeOf(context);
    final dateBloc = InheritedBloc.dateOf(context);
    final trainClassesBloc = InheritedBloc.trainClassesOf(context);
    final dateTimeTypeBloc = InheritedBloc.dateTimeTypeOf(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 130,
      child: StreamBuilder<NavState>(
          stream: navBloc.state.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            switch (snapshot.data) {
              case NavState.Main:
                return Align(
                  alignment: Alignment.centerRight,
                  child: SquircleButton(
                    callback: () => navBloc.state.add(NavState.Search),
                    type: ButtonType.Search,
                    top: false,
                    enabled: true,
                    raised: true,
                    fab: true,
                  ),
                );
              case NavState.Search:
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SquircleButton(
                      callback: () {
                        timeBloc.reset();
                        dateBloc.reset();
                      },
                      type: ButtonType.Reset,
                      enabled: false,
                      top: false,
                      raised: false,
                      fab: false,
                    ),
                    StreamBuilder<Input>(
                        stream: dateTimeTypeBloc.type.stream,
                        builder: (context, snapshot) {
                          switch (snapshot.data) {
                            case Input.departure:
                              return SquircleButton(
                                callback: () {
                                  dateTimeTypeBloc.switchTypes();
                                },
                                type: ButtonType.Departure,
                                enabled: true,
                                top: false,
                                raised: false,
                                fab: false,
                              );
                            case Input.arrival:
                              return SquircleButton(
                                callback: () {
                                  dateTimeTypeBloc.switchTypes();
                                },
                                type: ButtonType.Arrival,
                                enabled: true,
                                raised: false,
                                top: false,
                                fab: false,
                              );
                            default:
                              return Container();
                          }
                        }),
                    SquircleButton(
                      callback: () {
                        searchBloc.fetch();
                        resultsBloc.status.add(Status.searching);
                        navBloc.state.add(NavState.Schedule);
                      },
                      type: ButtonType.Search,
                      enabled: true,
                      raised: true,
                      top: false,
                      fab: true,
                    ),
                  ],
                );
              case NavState.Station:
                return Container();
              case NavState.Schedule:
                return Container();
              case NavState.Train:
                return Container();
            }
            return Container();
          }),
    );
  }
}
