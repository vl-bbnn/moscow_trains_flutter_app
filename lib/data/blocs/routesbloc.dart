// import 'dart:async';
// import 'dart:core';
// import 'dart:math';
// import 'package:rxdart/rxdart.dart';
// import 'package:trains/data/classes/listitem.dart';
// import 'package:trains/data/classes/station.dart';
// import 'package:trains/data/classes/train.dart';
// import 'package:trains/data/classes/warning.dart';
// import 'package:trains/data/src/request.dart';
// import 'inputtypebloc.dart';

// enum Status { searching, found, notFound }
// enum Mode { forward, reverse }

// class RoutesBloc {
//   RoutesBloc({this.allStationsStream}) {
//     setFromStation(allStationsStream.value.elementAt(0));
//     updateStation(allStationsStream.value.elementAt(1));
//     _timer();
//   }

//   switchMode() {
//     switch (mode.value) {
//       case Mode.forward:
//         mode.add(Mode.reverse);
//         break;
//       case Mode.reverse:
//         mode.add(Mode.forward);
//         break;
//     }
//   }

//   setFromStation(Station station) async {
//     from.add(station);
//     await _fetch();
//   }

//   updateStation(Station station) async {
//     to.add(station);
//     await _fetch();
//   }

//   _fetch() async {
//     if (from.value != null && to.value != null) {
//       toStatus.add(Status.searching);
//       final toList = await Request.search(
//           from.value, to.value, DateTime.now(), Input.departure);
//       if (toList.isNotEmpty) {
//         toStream.add(_insertWarnings(toList));
//         toStatus.add(Status.found);
//       } else
//         toStatus.add(Status.notFound);
//       fromStatus.add(Status.searching);
//       final fromList = await Request.search(
//           to.value, from.value, DateTime.now(), Input.departure);
//       if (fromList.isNotEmpty) {
//         fromStream.add(_insertWarnings(fromList));
//         fromStatus.add(Status.found);
//       } else
//         fromStatus.add(Status.notFound);

//       return true;
//     } else {
//       print("Null stations");
//       toStatus.add(Status.notFound);
//       fromStatus.add(Status.notFound);
//       return false;
//     }
//   }
//   final 
//   final toStream = BehaviorSubject.seeded(List<ListItem>());
//   final fromStream = BehaviorSubject.seeded(List<ListItem>());
//   final from = BehaviorSubject<Station>();
//   final to = BehaviorSubject<Station>();
//   final toStatus = BehaviorSubject<Status>.seeded(Status.notFound);
//   final fromStatus = BehaviorSubject<Status>.seeded(Status.notFound);
//   final mode = BehaviorSubject<Mode>.seeded(Mode.forward);
//   final BehaviorSubject<List<Station>> allStationsStream;

//   Timer periodicTimer;

//   _updateList(BehaviorSubject<List<ListItem>> list, status) {
//     final now = DateTime.now();
//     var first = 0;
//     if (list.value.isNotEmpty) {
//       list.value
//           .sublist(0, min(6, list.value.length))
//           .asMap()
//           .forEach((index, item) {
//         if (item.type == ListItemType.train &&
//             item.train.departure.isBefore(now)) first = index;
//       });
//       if (first >= list.value.length) {
//         status.add(Status.notFound);
//         list.add(List<ListItem>());
//       } else if (first != 0) {
//         list.add(list.value.sublist(first + 1));
//       } else {
//         final newList = list.value.where(test).sublist(0, first).
//       }
//     }
//   }

//   List<ListItem> _insertWarnings(List<Train> list) {
//     final newList = List<ListItem>();
//     var first = 0;
//     if (list.isNotEmpty) {
//       list.asMap().forEach((index, train) {
//         final target = index <= first
//             ? DateTime.now()
//             : list.elementAt(index - 1).departure;
//         newList.add(ListItem(
//             warning: Warning(train.departure, target),
//             type: ListItemType.warning));
//         newList.add(ListItem(train: train, type: ListItemType.train));
//         if (train.departure.isBefore(target)) first++;
//       });
//     }
//     return newList;
//   }

//   void _timer() {
//     periodicTimer = Timer.periodic(Duration(seconds: 15), (Timer t) {
//       _updateList(toStream, toStatus);
//       _updateList(fromStream, fromStatus);
//     });
//   }

//   dispose() {
//     from.close();
//     to.close();
//     toStream.close();
//     fromStream.close();
//     toStatus.close();
//     fromStatus.close();
//     mode.close();
//     periodicTimer?.cancel();
//   }
// }
