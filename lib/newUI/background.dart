import 'package:flutter/material.dart';
import 'package:trains/newData/blocs/inheritedbloc.dart';
import 'package:trains/newData/blocs/navbloc.dart';
import 'package:trains/newUI/mainpage.dart';
import 'package:trains/newUI/resultspage.dart';
import 'package:trains/newUI/searchpage.dart';
import 'package:trains/newUI/trainpage.dart';
import 'package:trains/newUI/stationselectpage.dart';

class Background extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navBloc = InheritedBloc.navOf(context);
    return StreamBuilder<NavState>(
        stream: navBloc.state.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          switch (snapshot.data) {
            case NavState.Main:
              return MainPage();
            case NavState.Search:
              return SearchPage();
            case NavState.Station:
              return StationSelectPage();
            case NavState.Schedule:
              return ResultsPage();
            case NavState.Train:
              return TrainPage();
          }
          return Container();
        });
  }
}
