// import 'package:flutter/material.dart';
// import 'package:trains/data/blocs/inheritedbloc.dart';
// import 'package:trains/data/blocs/routesbloc.dart';
// import 'package:trains/data/classes/listitem.dart';
// import 'package:trains/data/classes/station.dart';
// import 'package:trains/data/classes/train.dart';
// import 'package:trains/data/src/constants.dart';
// import 'package:trains/ui/background/schedule/traincard.dart';
// import 'package:trains/ui/background/screens/notfoundscreen.dart';
// import 'package:trains/ui/background/screens/searchingscreen.dart';
// import 'package:trains/ui/navigation/squirclebutton.dart';
// import 'package:trains/ui/res/stationcard.dart';
// import 'package:trains/ui/res/warningcard.dart';

// class MainPage extends StatelessWidget {

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         Expanded(
//             child: StreamBuilder<Mode>(
//                 stream: routesBloc.mode,
//                 builder: (context, mode) {
//                   if (!mode.hasData) return Container();
//                   var statusStream;
//                   var list;
//                   switch (mode.data) {
//                     case Mode.forward:
//                       statusStream = routesBloc.toStatus;
//                       list = routesBloc.toStream;
//                       break;
//                     case Mode.reverse:
//                       statusStream = routesBloc.fromStatus;
//                       list = routesBloc.fromStream;
//                       break;
//                   }
//                   return StreamBuilder<Status>(
//                     stream: statusStream,
//                     builder: (context, status) {
//                       if (!status.hasData) return Container();
//                       switch (status.data) {
//                         case Status.searching:
//                           return SearchingScreen();
//                         case Status.found:
//                           return Column(
//                             children: <Widget>[
//                               Expanded(
//                                 child: StreamBuilder<List<ListItem>>(
//                                     stream: list,
//                                     builder: (context, snapshot) {
//                                       if (!snapshot.hasData) return Container();
//                                       return StreamBuilder<Station>(
//                                           stream: routesBloc.from,
//                                           builder: (context, first) {
//                                             return StreamBuilder<Station>(
//                                                 stream: routesBloc.to,
//                                                 builder: (context, second) {
//                                                   return Padding(
//                                                     padding: const EdgeInsets
//                                                             .symmetric(
//                                                         horizontal: Constants
//                                                             .PADDING_PAGE),
//                                                     child: ListView(
//                                                       children: snapshot.data
//                                                           .map((item) {
//                                                         if (first.hasData &&
//                                                             second.hasData)
//                                                           switch (item.type) {
//                                                             case ListItemType
//                                                                 .train:
//                                                               return Padding(
//                                                                 padding: const EdgeInsets
//                                                                         .symmetric(
//                                                                     vertical:
//                                                                         Constants
//                                                                             .PADDING_MEDIUM),
//                                                                 child:
//                                                                     TrainCard(
//                                                                   train: item
//                                                                       .train,
//                                                                   from: mode.data ==
//                                                                           Mode
//                                                                               .forward
//                                                                       ? first
//                                                                           .data
//                                                                           .name
//                                                                       : second
//                                                                           .data
//                                                                           .name,
//                                                                   to: mode.data ==
//                                                                           Mode
//                                                                               .forward
//                                                                       ? second
//                                                                           .data
//                                                                           .name
//                                                                       : first
//                                                                           .data
//                                                                           .name,
//                                                                 ),
//                                                               );
//                                                             case ListItemType
//                                                                 .warning:
//                                                               return Padding(
//                                                                 padding: const EdgeInsets
//                                                                         .symmetric(
//                                                                     vertical:
//                                                                         Constants
//                                                                             .PADDING_MEDIUM),
//                                                                 child:
//                                                                     WarningCard(
//                                                                   warning: item
//                                                                       .warning,
//                                                                   label: "",
//                                                                 ),
//                                                               );
//                                                           }

//                                                         return Container();
//                                                       }).toList(),
//                                                     ),
//                                                   );
//                                                 });
//                                           });
//                                     }),
//                               ),
                              
//                             ],
//                           );
//                         case Status.notFound:
//                           return NotFoundScreen();
//                       }
//                       return Container();
//                     },
//                   );
//                 })),
//       ],
//     );
//   }
// }
