import 'package:trains/data/classes/station.dart';

enum TrainClass { regular, comfort, express }

class Train {
  DateTime departure;
  DateTime arrival;
  TrainClass trainClass;
  int price = 0;
  String uid;
  Station from;
  Station to;
  bool fromSelected = false;
  bool toSelected = false;
  int timeDiffToPrevTrain = 0;
  int timeDiffToTarget = 0;
  bool isLast = false;

  Train.fromDynamic(dynamic object) {
    from = Station (title:object['fromTitle'] ?? '',subtitle:object['fromSubtitle'] ?? '');
    to = Station (title:object['toTitle'] ?? '',subtitle:object['toSubtitle'] ?? '');
    fromSelected = object['fromSelected'];
    toSelected = object['toSelected'];
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
          trainClass = TrainClass.regular;
          break;
        }
    }
    if (!departure.difference(DateTime.now().toLocal()).isNegative)
      price = object['price'];
  }
}
