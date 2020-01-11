// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:trains/data/classes/thread.dart';
// import 'package:trains/data/src/constants.dart';
// import 'package:trains/data/src/helper.dart';

// class BackPanelThreadTitle extends StatefulWidget {
//   final Thread thread;
//   final Stream<int> stopsLeft;
//   final Stream<int> minutesLeft;

//   const BackPanelThreadTitle(
//       {Key key,
//       @required this.thread,
//       @required this.stopsLeft,
//       @required this.minutesLeft})
//       : super(key: key);

//   @override
//   _BackPanelThreadTitleState createState() => _BackPanelThreadTitleState();
// }

// class _BackPanelThreadTitleState extends State<BackPanelThreadTitle> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(18.0),
//       child: Material(
//         elevation: 1.0,
//         color: Constants.BACKGROUND_GREY_1DP,
//         shape:
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: <Widget>[
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Text(
//                         widget.thread.title,
//                         style: TextStyle(
//                             color: Constants.whiteHigh,
//                             fontSize: Constants.TEXT_SIZE_BIG,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 4.0),
//                       child: Text(
//                         Helper.trainTypeName(widget.thread.type) +
//                             " № " +
//                             widget.thread.number.toString(),
//                         style: TextStyle(
//                             color: Constants.whiteMedium,
//                             fontSize: Constants.TEXT_SIZE_MEDIUM,
//                             fontWeight: FontWeight.w500),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 8.0),
//                       child: Row(
//                         children: <Widget>[
//                           StreamBuilder<int>(
//                               stream: widget.minutesLeft,
//                               builder: (context, snapshot) {
//                                 final minutesLeft =
//                                     snapshot.hasData ? snapshot.data : 0;
//                                 return Text(
//                                   "В пути " +
//                                       Helper.minutesToText(minutesLeft)
//                                           .elementAt(4) +
//                                       ", ",
//                                   style: TextStyle(
//                                       color: Constants.whiteMedium,
//                                       fontSize: Constants.TEXT_SIZE_MEDIUM,
//                                       fontWeight: FontWeight.w500),
//                                 );
//                               }),
//                           StreamBuilder<int>(
//                               stream: widget.stopsLeft,
//                               builder: (context, snapshot) {
//                                 final stopsLeft =
//                                     snapshot.hasData ? snapshot.data : -1;
//                                 return Text(
//                                   Helper.stopsText(stopsLeft).elementAt(0),
//                                   style: TextStyle(
//                                       color: Constants.whiteMedium,
//                                       fontSize: Constants.TEXT_SIZE_MEDIUM,
//                                       fontWeight: FontWeight.w500),
//                                 );
//                               }),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 4.0),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 12.0),
//                       child: Icon(
//                         Icons.notifications_none,
//                         color: Constants.whiteMedium,
//                         size: Constants.TEXT_SIZE_MAX,
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(vertical: 12.0),
//                       child: Icon(
//                         Icons.bookmark_border,
//                         color: Constants.whiteMedium,
//                         size: Constants.TEXT_SIZE_MAX,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
