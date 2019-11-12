// import 'package:flutter/material.dart';
// import 'package:trains/data/src/constants.dart';
// import 'package:trains/data/src/helper.dart';
// import 'package:trains/newData/blocs/inheritedbloc.dart';
// import 'package:trains/newData/blocs/datetimebloc.dart';
// import 'package:trains/newUI/datetimeselector.dart';

// class DateTimeSelectPage extends StatefulWidget {
//   @override
//   _DateTimeSelectPageState createState() => _DateTimeSelectPageState();
// }

// class _DateTimeSelectPageState extends State<DateTimeSelectPage> {
//   @override
//   Widget build(BuildContext context) {
//     final dateBloc = InheritedBloc.dateOf(context);
//     return Scaffold(
//       body: Stack(
//         children: <Widget>[
//           Column(
//             children: <Widget>[
//               Container(
//                 height: 120,
//               ),
//               Expanded(
//                 child: Container(),
//               ),
//               Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Material(
//                   color: Constants.DARK,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.only(
//                           topLeft: Radius.circular(38.5),
//                           topRight: Radius.circular(38.5))),
//                   child: Column(
//                     children: <Widget>[
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           StreamBuilder<int>(
//                               stream: dateBloc.prevMonth.stream,
//                               builder: (context, snapshot) {
//                                 if (!snapshot.hasData) return Container();
//                                 final enabled =
//                                     snapshot.data != null && snapshot.data >= 0;
//                                 return GestureDetector(
//                                   behavior: HitTestBehavior.translucent,
//                                   onTap: () {
//                                     if (enabled)
//                                       dateBloc.scrollToIndex(snapshot.data);
//                                   },
//                                   child: Container(
//                                     width: 83,
//                                     height: 100,
//                                     child: Center(
//                                       child: Icon(
//                                         Icons.arrow_back_ios,
//                                         color: enabled
//                                             ? Constants.PRIMARY
//                                             : Constants.GREY,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }),
//                           Month(),
//                           StreamBuilder<int>(
//                               stream: dateBloc.nextMonth.stream,
//                               builder: (context, snapshot) {
//                                 if (!snapshot.hasData) return Container();
//                                 final enabled =
//                                     snapshot.data != null && snapshot.data >= 0;
//                                 return GestureDetector(
//                                   behavior: HitTestBehavior.translucent,
//                                   onTap: () {
//                                     if (enabled)
//                                       dateBloc.scrollToIndex(snapshot.data);
//                                   },
//                                   child: Container(
//                                     width: 83,
//                                     height: 100,
//                                     child: Center(
//                                       child: Icon(
//                                         Icons.arrow_forward_ios,
//                                         color: enabled
//                                             ? Constants.PRIMARY
//                                             : Constants.GREY,
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               }),
//                         ],
//                       ),
//                       DateTimeSelector(
//                         type: DateTimeType.Dates,
//                       ),
//                       DateTimeSelector(
//                         type: DateTimeType.Hours,
//                       ),
//                       DateTimeSelector(
//                         type: DateTimeType.Minutes,
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               Container(
//                 height: 130,
//                 color: Constants.DARK,
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }

// class Month extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final dateTimeBloc = InheritedBloc.dateOf(context);
//     return StreamBuilder<dynamic>(
//         stream: dateTimeBloc.selected.stream,
//         builder: (context, snapshot) {
//           if (!snapshot.hasData) return Container();
//           final date = snapshot.data as DateTime;
//           return Text(
//             Helper.month(date.month)["regular"],
//             style: Theme.of(context).textTheme.title,
//           );
//         });
//   }
// }
