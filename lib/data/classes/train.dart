
enum TrainType { regular, comfort, express }

class Train {
  DateTime departure = DateTime.now();
  DateTime arrival;
  TrainType type;
  int price = 0;
  String uid;
  String from;
  String to;
  bool isLast = false;
  bool goingFromSelected = false;
  bool goingToSelected = false;
  int timeDiff = 0;

  setTimeDiff(int newDiff){
    
  }

  Train.fromDynamic(dynamic object) {
    String _title = object['title'];
    from = _title.split('—')[0].trim();
    to = _title.split('—')[1].trim();
    uid = object['uid'];
    departure = DateTime.parse(object['departure']).toLocal();
    arrival = DateTime.parse(object['arrival']).toLocal();
    isLast = object['isLast'];
    switch (object['train_type']) {
      case 'last':
        {
          type = TrainType.express;
          break;
        }
      case 'lastm':
        {
          type = TrainType.comfort;
          break;
        }
      default:
        {
          type = TrainType.regular;
          break;
        }
    }
    if (!departure.difference(DateTime.now().toLocal()).isNegative)
      price = object['price'];
  }
}
