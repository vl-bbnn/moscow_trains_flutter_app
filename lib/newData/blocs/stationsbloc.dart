import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/newData/classes/station.dart';

class StationsBloc {

  init() async {
    await _loadStations();
    await Future.delayed(Duration(seconds: 2));
  }

  final _allStations = BehaviorSubject<List<Station>>();

  Stream<List<Station>> get stream =>
      _allStations.stream;

  _loadStations() async {
    final stationsRef = Firestore.instance
        .collection("stations")
        .orderBy("priority")
        .orderBy("order")
        .reference();
    final query = await stationsRef.getDocuments();
    final tempList = new List<Station>();
    query.documents.forEach((doc) {
      tempList.add(Station.fromDocumentSnapshot(doc));
    });
    _allStations.add(tempList);
    print(tempList.length.toString() + " stations loaded");
  }

}
