import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/navbloc.dart';
import 'package:trains/ui/background/schedule/schedulepage.dart';
import 'package:trains/ui/background/search/searchpage.dart';
import 'package:trains/ui/background/stationselect/stationselectpage.dart';
import 'package:trains/ui/background/train/trainpage.dart';

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
              return SchedulePage();
            case NavState.Search:
              return SearchPage();
            case NavState.Station:
              return StationSelectPage();
            // case NavState.Schedule:
            //   return SchedulePage();
            case NavState.Train:
              return TrainPage();
          }
          return Container();
        });
  }
}
