// import 'package:flutter/material.dart';
// import 'package:trains/data/blocs/frontpanelbloc.dart';
// import 'package:trains/data/blocs/inheritedbloc.dart';
// import 'package:trains/ui/searchstations.dart';
// import 'package:trains/ui/stationselectpanel.dart';

// class Background extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<FrontPanelState>(
//         stream: InheritedBloc.frontPanelBloc.state.stream,
//         builder: (context, frontPanelStateStream) {
//           if (!frontPanelStateStream.hasData) return Container();
//           switch (frontPanelStateStream.data) {
//             case FrontPanelState.Search:
//               return SearchStations();
//             case FrontPanelState.StationSelect:
//               return StationSelectPanel();
//           }
//           return Container();
//         });
//   }
// }
