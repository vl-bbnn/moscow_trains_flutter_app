import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/ui/schedulepage/schedulepage.dart';
import 'package:trains/ui/stationselectpage/stationselectpage.dart';
import 'data/blocs/appnavigationbloc.dart';

class Background extends StatelessWidget {
  final List<AppState> appStates;
  final Sizes sizes;

  const Background({Key key, this.appStates, this.sizes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalBloc.of(context);
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
                  // color: Colors.blue,
                  );
            case AppState.Schedule:
              return SchedulePage(sizes: sizes);
            case AppState.StationSelect:
              return SuggestionsList(sizes: sizes);
          }
          return Container();
        });
  }
}
