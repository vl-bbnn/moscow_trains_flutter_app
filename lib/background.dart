import 'package:flutter/material.dart';
import 'package:trains/ui/schedulepage/schedulepage.dart';
import 'package:trains/ui/stationselectpage/stationselectpage.dart';
import 'data/blocs/appnavigationbloc.dart';
import 'data/blocs/globalvalues.dart';

class Background extends StatelessWidget {
  final List<AppState> appStates;

  const Background({Key key, this.appStates}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    AppState oldAppState = AppState.Launch;

    return StreamBuilder<AppState>(
        stream: globalValues.appNavigationBloc.currentAppState,
        builder: (context, pageStateSnapshot) {
          // print("Background: " + pageStateSnapshot.data.toString());
          final newAppState =
              pageStateSnapshot.hasData ? pageStateSnapshot.data : oldAppState;
          oldAppState = newAppState;
          switch (newAppState) {
            case AppState.Launch:
              return Container(
                color: Colors.blue,
              );
            case AppState.Schedule:
              return SchedulePage();
            case AppState.StationSelect:
              return SuggestionsList();
          }
          return Container();
        });
  }
}
