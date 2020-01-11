// import 'package:flutter/material.dart';
// import 'package:trains/data/blocs/inheritedbloc.dart';
// import 'package:trains/data/classes/train.dart';
// import 'package:trains/data/src/constants.dart';
// import 'package:trains/ui/background/schedule/bigtraincard.dart';
// import 'package:trains/ui/background/schedule/traincard.dart';
// import 'package:trains/ui/background/search/selectedtime.dart';

// class TrainSelector extends StatelessWidget {
//   final height = Constants.TRAINCARD_HEIGHT;

//   @override
//   Widget build(BuildContext context) {
//     final trainsBloc = InheritedBloc.trainsOf(context);
//     final listviewEndPadding = MediaQuery.of(context).size.height -
//         Constants.PADDING_REGULAR * 4 -
//         Constants.TRAINCARD_HEIGHT * 3;
//     trainsBloc.rebuilt();
//     return Stack(
//       alignment: Alignment.center,
//       children: <Widget>[
//         Container(
//             child: StreamBuilder<List<Train>>(
//                 stream: trainsBloc.results.stream,
//                 builder: (context, listStream) {
//                   if (!listStream.hasData) return Container();
//                   return StreamBuilder<int>(
//                       stream: trainsBloc.selected,
//                       builder: (context, selectedStream) {
//                         return ListView.builder(
//                             scrollDirection: Axis.vertical,
//                             itemCount: listStream.data.length,
//                             physics: NeverScrollableScrollPhysics(),
//                             controller: trainsBloc.scroll,
//                             itemBuilder: (context, index) {
//                               final train = listStream.data.elementAt(index);
//                               final first = index == 0;
//                               final last = index == listStream.data.length - 1;
//                               final selected = index == selectedStream.data;
//                               if (first)
//                                 return Column(
//                                   children: <Widget>[
//                                     SelectedTime(),
//                                     Padding(
//                                       padding: const EdgeInsets.all(
//                                           Constants.PADDING_REGULAR),
//                                       child: TrainCard(
//                                         train: train,
//                                         selected: selected,
//                                       ),
//                                     ),
//                                   ],
//                                 );
//                               else if (last)
//                                 return Column(
//                                   children: <Widget>[
//                                     Padding(
//                                       padding: const EdgeInsets.all(
//                                           Constants.PADDING_REGULAR),
//                                       child: TrainCard(
//                                         train: train,
//                                         selected: selected,
//                                       ),
//                                     ),
//                                     Container(
//                                       height: listviewEndPadding,
//                                     ),
//                                   ],
//                                 );
//                               else
//                                 return Padding(
//                                   padding: const EdgeInsets.all(
//                                       Constants.PADDING_REGULAR),
//                                   child: TrainCard(
//                                     train: train,
//                                     selected: selected,
//                                   ),
//                                 );
//                             });
//                       });
//                 })),
//         // Positioned.fill(
//         //   child: Container(
//         //     decoration: BoxDecoration(
//         //         gradient: LinearGradient(
//         //             begin: Alignment.topCenter,
//         //             end: Alignment.bottomCenter,
//         //             stops: [
//         //           0.15,
//         //           0.25,
//         //           0.5,
//         //           0.6
//         //         ],
//         //             colors: [
//         //           Colors.transparent,
//         //           Constants.BACKGROUND,
//         //           Constants.BACKGROUND,
//         //           Colors.transparent,
//         //         ])),
//         //   ),
//         // ),
//         Align(
//           alignment: Alignment.topCenter,
//           child: Container(
//             padding:
//                 EdgeInsets.only(top: MediaQuery.of(context).padding.top + 100),
//             child: StreamBuilder<int>(
//                 stream: trainsBloc.selected,
//                 builder: (context, selectedStream) {
//                   if (!selectedStream.hasData ||
//                       selectedStream.data < 0 ||
//                       selectedStream.data > trainsBloc.results.value.length - 1)
//                     return Container();
//                   return BigTrainCard(
//                     train:
//                         trainsBloc.results.value.elementAt(selectedStream.data),
//                   );
//                 }),
//           ),
//         ),
//       ],
//     );
//   }
// }
