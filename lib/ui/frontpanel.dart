// import 'package:flutter/material.dart';
// import 'package:trains/data/blocs/inheritedbloc.dart';
// import 'package:trains/data/blocs/searchbloc.dart';
// import 'package:trains/data/classes/train.dart';
// import 'package:trains/ui/res/mycolors.dart';
// import 'package:trains/ui/res/traincard.dart';
// import 'package:trains/ui/screens/errorscreen.dart';
// import 'package:trains/ui/screens/notfoundscreen.dart';
// import 'package:trains/ui/screens/searchingscreen.dart';

// class FrontPanel extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       width: MediaQuery.of(context).size.width,
//       decoration: ShapeDecoration(
//           color: MyColors.ELEVATED,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(28), topRight: Radius.circular(28)),
//           )),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           Container(
//             height: 30,
//             child: Center(
//               child: Container(
//                 width: 40,
//                 height: 6,
//                 decoration: ShapeDecoration(
//                     color: MyColors.SECONDARY,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(3),
//                     )),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: 10,
//           ),
//           StreamBuilder<double>(
//               stream: InheritedBloc.frontPanelBloc.panelMaxHeight,
//               builder: (context, snapshot) {
//                 if (!snapshot.hasData) return Container();
//                 return SizedBox(
//                   height: snapshot.data - 40,
//                   child: StreamBuilder<Status>(
//                       stream: InheritedBloc.searchBloc.status,
//                       builder: (context, status) {
//                         switch (status.data) {
//                           case Status.notFound:
//                             return NotFoundScreen();
//                           case Status.searching:
//                             return SearchingScreen();
//                           case Status.found:
//                             return StreamBuilder<List<Train>>(
//                                 stream: InheritedBloc.trainsBloc.results,
//                                 builder: (context, list) {
//                                   if (!list.hasData) return NotFoundScreen();
//                                   return Container(
//                                     // color: Colors.indigo,
//                                     padding: const EdgeInsets.symmetric(
//                                         horizontal: 40),
//                                     child: StreamBuilder<ScrollController>(
//                                         stream: InheritedBloc.frontPanelBloc
//                                             .scheduleScrollController,
//                                         builder:
//                                             (context, scrollControllerStream) {
//                                           if (!snapshot.hasData)
//                                             return Container();
//                                           return ListView(
//                                             controller:
//                                                 scrollControllerStream.data,
//                                             children: list.data
//                                                 .map((train) => TrainCard(
//                                                       train: train,
//                                                       first: train.uid ==
//                                                           list.data.first.uid,
//                                                     ))
//                                                 .toList(),
//                                           );
//                                         }),
//                                   );
//                                 });
//                           default:
//                             return ErrorScreen();
//                         }
//                       }),
//                 );
//               }),
//         ],
//       ),
//     );
//   }
// }
