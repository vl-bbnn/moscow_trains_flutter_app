import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/classes/station.dart';

class StationsBloc {
  init() async {
    await _loadStations();
  }

  final allStations = BehaviorSubject<List<Station>>();

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
    allStations.add(tempList);
    print(tempList.length.toString() + " stations loaded");
  }
}
