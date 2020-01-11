import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/blocs/navbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/navigation/selectedstationcard.dart';
import 'package:trains/ui/navigation/squirclebutton.dart';

class BottomNavPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navBloc = InheritedBloc.navOf(context);
    final searchBloc = InheritedBloc.searchOf(context);
    final resultsBloc = InheritedBloc.trainsOf(context);
    final timeBloc = InheritedBloc.timeOf(context);
    final dateBloc = InheritedBloc.dateOf(context);
    final dateTimeTypeBloc = InheritedBloc.dateTimeTypeOf(context);

    return Container(
      width: MediaQuery.of(context).size.width,
      height: 180,
      child: StreamBuilder<NavState>(
          stream: navBloc.state.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            switch (snapshot.data) {
              case NavState.Main:
                return SelectedStationsCard();
              case NavState.Search:
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: Constants.PADDING_PAGE),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SquircleButton(
                        callback: () {
                          timeBloc.reset();
                          dateBloc.reset();
                        },
                        type: ButtonType.Reset,
                        enabled: false,
                        outlined: false,
                        raised: false,
                        fab: false,
                      ),
                  
                      SquircleButton(
                        callback: () {
                          searchBloc.fetch();
                          resultsBloc.status.add(Status.searching);
                          navBloc.state.add(NavState.Main);
                        },
                        type: ButtonType.Search,
                        enabled: true,
                        raised: true,
                        outlined: false,
                        fab: true,
                      ),
                    ],
                  ),
                );
              case NavState.Station:
                return Container();
              // case NavState.Schedule:
              //   return Container();
              case NavState.Train:
                return Container();
            }
            return Container();
          }),
    );
  }
}
