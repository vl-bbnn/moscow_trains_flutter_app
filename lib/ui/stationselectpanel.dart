// import 'dart:math';
// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:trains/data/blocs/frontpanelbloc.dart';
// import 'package:trains/data/blocs/inheritedbloc.dart';
// import 'package:trains/data/blocs/searchbloc.dart';
// import 'package:trains/data/classes/station.dart';
// import 'package:trains/ui/res/mycolors.dart';
// import 'package:trains/ui/res/stationcard.dart';

// class StationSelectPanel extends StatefulWidget {
//   @override
//   _StationSelectPanelState createState() => _StationSelectPanelState();
// }

// class _StationSelectPanelState extends State<StationSelectPanel>
//     with WidgetsBindingObserver {
//   var _overlap = 0.0;
//   var _keyboardVisible = false;

//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addObserver(this);
//   }

//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }

//   @override
//   void didChangeMetrics() {
//     final renderBox = (context.findRenderObject() as RenderBox);
//     final offset = renderBox.localToGlobal(Offset.zero);
//     final widgetRect = Rect.fromLTWH(
//       offset.dx,
//       offset.dy,
//       renderBox.size.width,
//       renderBox.size.height,
//     );
//     final keyboardTopPixels =
//         window.physicalSize.height - window.viewInsets.bottom;
//     final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
//     if (this.mounted)
//       setState(() {
//         _keyboardVisible = widgetRect.bottom != keyboardTopPoints;
//         _overlap = _keyboardVisible
//             ? widgetRect.bottom - keyboardTopPoints
//             : MediaQuery.of(context).viewPadding.bottom;
//       });
//   }

//   _title(type) {
//     switch (type) {
//       case Input.departure:
//         return "Отправления";
//       case Input.arrival:
//         return "Прибытия";
//     }
//   }

//   _stream(type) {
//     switch (type) {
//       case Input.departure:
//         return InheritedBloc.searchBloc.fromStation;
//       case Input.arrival:
//         return InheritedBloc.searchBloc.toStation;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final frontPanelBloc = InheritedBloc.frontPanelBloc;
//     frontPanelBloc.focus.add(InheritedBloc.typingSuggestionsBloc.focusNode);
//     final cardWidth = MediaQuery.of(context).size.width - 80;
//     return Column(
//       children: <Widget>[
//         StreamBuilder<Input>(
//             stream: InheritedBloc.searchBloc.stationType,
//             builder: (context, stationTypeStream) {
//               if (!stationTypeStream.hasData) return Container();
//               return Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 40),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     SizedBox(
//                       height: MediaQuery.of(context).padding.top + 20,
//                     ),
//                     GestureDetector(
//                       behavior: HitTestBehavior.translucent,
//                       onTap: () =>
//                           frontPanelBloc.state.add(FrontPanelState.Search),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Icon(
//                             Icons.arrow_back,
//                             size: 24,
//                             color: MyColors.BLACK,
//                           ),
//                           Text(
//                             _title(stationTypeStream.data).toUpperCase(),
//                             style: TextStyle(
//                                 fontSize: 18,
//                                 fontFamily: "Montserrat",
//                                 fontWeight: FontWeight.w500,
//                                 color: MyColors.BLACK),
//                           ),
//                           SizedBox(
//                             width: 24,
//                             height: 24,
//                           )
//                         ],
//                       ),
//                     ),
//                     SizedBox(
//                       height: 40,
//                     ),
//                     StreamBuilder<Station>(
//                         stream: _stream(stationTypeStream.data),
//                         builder: (context, snapshot) {
//                           if (!snapshot.hasData) return Container();
//                           return StationCard(
//                             width: cardWidth,
//                             size: StationCardSize.regular,
//                             station: snapshot.data,
//                           );
//                         }),
//                     SizedBox(
//                       height: 40,
//                     ),
//                   ],
//                 ),
//               );
//             }),
//         Expanded(
//           child: Container(
//             decoration: ShapeDecoration(
//                 color: MyColors.ELEVATED,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.only(
//                         topRight: Radius.circular(38.5),
//                         topLeft: Radius.circular(38.5)))),
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 Expanded(
//                   child: StreamBuilder<List<Station>>(
//                       stream: InheritedBloc.typingSuggestionsBloc.suggestions,
//                       builder: (context, snapshot) {
//                         if (!snapshot.hasData) return Container();
//                         final list = snapshot.data.sublist(
//                             0,
//                             min(_keyboardVisible ? 3 : 5,
//                                 snapshot.data.length));
//                         return Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                           children: list
//                               .map((station) => GestureDetector(
//                                     onTap: () {
//                                       InheritedBloc.typingSuggestionsBloc
//                                           .updateStation(station);
//                                       frontPanelBloc.state
//                                           .add(FrontPanelState.Search);
//                                     },
//                                     behavior: HitTestBehavior.translucent,
//                                     child: StationCard(
//                                       size: StationCardSize.regular,
//                                       width: cardWidth,
//                                       station: station,
//                                     ),
//                                   ))
//                               .toList(),
//                         );
//                       }),
//                 ),
//                 Container(
//                   decoration: ShapeDecoration(
//                       color: MyColors.SECONDARY,
//                       shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.all(Radius.circular(16)))),
//                   padding: const EdgeInsets.symmetric(
//                       vertical: 10.0, horizontal: 30),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       SizedBox(
//                         width: 95,
//                         child: TextField(
//                           textAlign: TextAlign.left,
//                           autofocus: true,
//                           enableSuggestions: false,
//                           autocorrect: false,
//                           focusNode:
//                               InheritedBloc.typingSuggestionsBloc.focusNode,
//                           textCapitalization: TextCapitalization.characters,
//                           cursorColor: MyColors.ELEVATED,
//                           cursorWidth: 3,
//                           keyboardType: TextInputType.text,
//                           style: TextStyle(
//                               color: MyColors.BLACK,
//                               fontSize: 14,
//                               fontFamily: "PT Root UI",
//                               fontWeight: FontWeight.w500),
//                           controller:
//                               InheritedBloc.typingSuggestionsBloc.textfield,
//                           decoration: null,
//                         ),
//                       ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       GestureDetector(
//                           behavior: HitTestBehavior.opaque,
//                           child: Container(
//                             width: 18,
//                             height: 18,
//                             child: InheritedBloc.typingSuggestionsBloc.textfield
//                                     .text.isNotEmpty
//                                 ? Center(
//                                     child: Icon(
//                                       Icons.close,
//                                       size: 18,
//                                       color: MyColors.GREY,
//                                     ),
//                                   )
//                                 : Container(),
//                           ),
//                           onTap: () =>
//                               InheritedBloc.typingSuggestionsBloc.clear()),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 25,
//                 )
//               ],
//             ),
//           ),
//         ),
//         AnimatedContainer(
//           height: _overlap,
//           duration: Duration(milliseconds: 300),
//           curve: Curves.easeOut,
//           color: MyColors.ELEVATED,
//         )
//       ],
//     );
//   }
// }
