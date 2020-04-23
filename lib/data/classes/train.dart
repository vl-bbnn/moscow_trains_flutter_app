import 'package:trains/data/classes/station.dart';

enum TrainClass { standart, comfort, express }

class Train {
  DateTime departure;
  DateTime arrival;
  TrainClass trainClass;
  int price;
  String uid;
  Station from;
  Station to;
  bool departureSelected;
  bool arrivalSelected;

  Train(
      {this.departure,
      this.arrival,
      this.trainClass,
      this.price: 0,
      this.uid: "",
      this.from,
      this.departureSelected: false,
      this.to,
      this.arrivalSelected: false})
      : assert(departure != null &&
            arrival != null &&
            trainClass != null &&
            from != null &&
            to != null);

  Train.fromDynamic(dynamic object) {
    from = Station(
        title: object['fromTitle'] ?? '',
        subtitle: object['fromSubtitle'] ?? '');
    to = Station(
        title: object['toTitle'] ?? '', subtitle: object['toSubtitle'] ?? '');
    departureSelected = object['fromSelected'];
    arrivalSelected = object['toSelected'];
    uid = object['uid'];
    departure = DateTime.parse(object['departure']).toLocal();
    arrival = DateTime.parse(object['arrival']).toLocal();
    switch (object['trainClass']) {
      case 'last':
        {
          trainClass = TrainClass.express;
          break;
        }
      case 'lastm':
        {
          trainClass = TrainClass.comfort;
          break;
        }
      default:
        {
          trainClass = TrainClass.standart;
          break;
        }
    }
    if (!departure.difference(DateTime.now().toLocal()).isNegative)
      price = object['price'];
  }
}
