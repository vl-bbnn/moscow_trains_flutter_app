// import 'package:flutter/material.dart';
// import 'package:trains/data/src/constants.dart';
// import 'package:trains/data/src/helper.dart';
// import 'package:trains/newData/blocs/inheritedbloc.dart';
// import 'package:trains/newData/blocs/datetimebloc.dart';

// class DateTimeSelector extends StatelessWidget {
//   final DateTimeType type;
//   final double size;
//   const DateTimeSelector({Key key, this.type, this.size}) : super(key: key);

//   DateTimeBloc _bloc(BuildContext context) {
//     switch (type) {
//       case DateTimeType.Hours:
//         return InheritedBloc.timeOf(context);
//       case DateTimeType.Minutes:
//         return InheritedBloc.minutesOf(context);
//         break;
//       case DateTimeType.Dates:
//         return InheritedBloc.dateOf(context);
//         break;
//     }
//   }

//   Axis _axis() {
//     switch (type) {
//       case DateTimeType.Hours:
//         return Axis.vertical;
//       case DateTimeType.Minutes:
//         return Axis.vertical;
//         break;
//       case DateTimeType.Dates:
//         return Axis.horizontal;
//         break;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     var dragStartPosition = 0.0;
//     var initialOffset = 0.0;
//     final timeBloc = _bloc(context);
//     final listviewPadding = MediaQuery.of(context).size.width / 2 -
//         Constants.TIMECARD_WIDTH / 2 -
//         Constants.PADDING_REGULAR;
//     timeBloc.rebuilt();
//     final width = timeBloc.elementWidth;
//     final height = timeBloc.elementHeight;
//     return Container(
//       color: Colors.red,
//       height: height * 1.1,
//       child: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           Container(
//               height: height,
//               child: NotificationListener<ScrollNotification>(
//                 onNotification: (notification) {
//                   final newOffset = timeBloc.scroll.offset;
//                   if (!timeBloc.timerShouldUpdate.value &&
//                       newOffset >= 0 &&
//                       newOffset <= timeBloc.scroll.position.maxScrollExtent) {
//                     final newIndex =
//                         (newOffset / (width + Constants.PADDING_REGULAR * 2))
//                             .round();
//                     if (notification is ScrollEndNotification)
//                       timeBloc.scrollToIndex(newIndex);
//                     if (notification is ScrollUpdateNotification)
//                       timeBloc.update(newIndex);
//                   }
//                   return false;
//                 },
//                 child: StreamBuilder<List<dynamic>>(
//                     stream: timeBloc.list.stream,
//                     builder: (context, snapshot) {
//                       if (!snapshot.hasData) return Container();
//                       return ListView.builder(
//                           scrollDirection: _axis(),
//                           itemCount: snapshot.data.length,
//                           physics: NeverScrollableScrollPhysics(),
//                           controller: timeBloc.scroll,
//                           itemBuilder: (context, index) {
//                             final hour = snapshot.data.elementAt(index);
//                             return Row(
//                               children: <Widget>[
//                                 Container(
//                                   width: index == 0 ? listviewPadding : 0.0,
//                                 ),
//                                 Padding(
//                                   padding: const EdgeInsets.all(
//                                       Constants.PADDING_REGULAR),
//                                   child: TimeCardRegular(
//                                     type: type,
//                                     width: width,
//                                     height: height,
//                                     value: hour,
//                                   ),
//                                 ),
//                                 Container(
//                                   width: index == snapshot.data.length - 1
//                                       ? listviewPadding
//                                       : 0.0,
//                                 ),
//                               ],
//                             );
//                           });
//                     }),
//               )),
//           Align(
//             alignment: Alignment.center,
//             child: Container(
//               child: StreamBuilder<dynamic>(
//                   stream: timeBloc.selected,
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) return Container();
//                     return TimeCardSelected(
//                       type: type,
//                       width: width,
//                       height: height,
//                       value: snapshot.data,
//                     );
//                   }),
//             ),
//           ),
//           Positioned.fill(
//               child: GestureDetector(
//             behavior: HitTestBehavior.opaque,
//             onVerticalDragDown: (details) {
//               dragStartPosition = details.localPosition.dx;
//               initialOffset = timeBloc.scroll.offset;
//               timeBloc.timerShouldUpdate.add(false);
//             },
//             onVerticalDragUpdate: (details) {
//               final newOffset =
//                   initialOffset + dragStartPosition - details.localPosition.dx;
//               if (newOffset >= 0 &&
//                   newOffset < timeBloc.scroll.position.maxScrollExtent) {
//                 timeBloc.scroll.jumpTo(newOffset);
//               }
//             },
//             onVerticalDragEnd: (details) {
//               final deltaIndex = (details.primaryVelocity /
//                       MediaQuery.of(context).size.width /
//                       4)
//                   .round();
//               final offset = timeBloc.scroll.offset;
//               var index =
//                   (offset / (width + Constants.PADDING_REGULAR * 2)).round();
//               if (deltaIndex.abs() > 2)
//                 index = timeBloc.index.value - deltaIndex;
//               timeBloc.scrollToIndex(index);
//             },
//           ))
//         ],
//       ),
//     );
//   }
// }

// class TimeCardSelected extends StatelessWidget {
//   final DateTimeType type;
//   final dynamic value;
//   final double width;
//   final double height;

//   const TimeCardSelected(
//       {Key key,
//       @required this.value,
//       @required this.width,
//       @required this.height,
//       @required this.type})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     switch (type) {
//       case DateTimeType.Hours:
//       case DateTimeType.Minutes:
//         final time = value as int;
//         return Container(
//           width: width * 1.3,
//           height: height * 1.0,
//           child: Material(
//             shadowColor: Constants.SHADE,
//             color: Constants.SECONDARY,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(18.5))),
//             child: Center(
//               child: Padding(
//                 padding: const EdgeInsets.all(Constants.PADDING_REGULAR * 2),
//                 child: Text(
//                   value < 10 ? "0" + time.toString() : time.toString(),
//                   style: TextStyle(
//                     color: Constants.PRIMARY,
//                     fontFamily: "LexendDeca",
//                     fontSize: 36,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       case DateTimeType.Dates:
//         final date = value as DateTime;
//         return Container(
//           width: width * 1.3,
//           height: height * 1.0,
//           child: Material(
//             shadowColor: Constants.SHADE,
//             color: Constants.SECONDARY,
//             shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.all(Radius.circular(18.5))),
//             child: Padding(
//               padding: const EdgeInsets.all(Constants.PADDING_REGULAR),
//               child: Column(
//                 children: <Widget>[
//                   Padding(
//                     padding: const EdgeInsets.all(Constants.PADDING_REGULAR),
//                     child: Text(
//                       Helper.weekday(date.weekday),
//                       style: TextStyle(
//                           color: Constants.PRIMARY,
//                           fontFamily: "Montserrat",
//                           fontSize: 18,
//                           fontWeight: FontWeight.w500),
//                     ),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(Constants.PADDING_REGULAR),
//                     child: Text(
//                       date.day.toString(),
//                       style: TextStyle(
//                         color: Constants.PRIMARY,
//                         fontFamily: "LexendDeca",
//                         fontSize: 36,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         );
//     }
//     return Container();
//   }
// }

// class TimeCardRegular extends StatelessWidget {
//   final DateTimeType type;
//   final dynamic value;
//   final double width;
//   final double height;

//   const TimeCardRegular(
//       {Key key,
//       @required this.value,
//       @required this.width,
//       @required this.height,
//       @required this.type})
//       : super(key: key);
//   @override
//   Widget build(BuildContext context) {
//     switch (type) {
//       case DateTimeType.Hours:
//       case DateTimeType.Minutes:
//         final time = value as int;
//         return Container(
//           width: width,
//           height: height,
//           child: Center(
//             child: Padding(
//               padding: const EdgeInsets.all(Constants.PADDING_REGULAR * 2),
//               child: Text(
//                 value < 10 ? "0" + time.toString() : time.toString(),
//                 style: TextStyle(
//                   color: Constants.GREY,
//                   fontFamily: "LexendDeca",
//                   fontSize: 22,
//                 ),
//               ),
//             ),
//           ),
//         );
//       case DateTimeType.Dates:
//         final date = value as DateTime;
//         return Container(
//           width: width,
//           height: height,
//           child: Padding(
//             padding: const EdgeInsets.all(Constants.PADDING_REGULAR),
//             child: Column(
//               children: <Widget>[
//                 Padding(
//                   padding: const EdgeInsets.all(Constants.PADDING_REGULAR),
//                   child: Text(
//                     Helper.weekday(date.weekday),
//                     style: TextStyle(
//                         color: Constants.GREY,
//                         fontFamily: "Montserrat",
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500),
//                   ),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(Constants.PADDING_REGULAR),
//                   child: Text(
//                     date.day.toString(),
//                     style: TextStyle(
//                       color: Constants.GREY,
//                       fontFamily: "LexendDeca",
//                       fontSize: 24,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//     }
//     return Container();
//   }
// }
