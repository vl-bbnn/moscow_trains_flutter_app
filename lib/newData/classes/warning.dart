import 'package:trains/newData/blocs/inputtypebloc.dart';

class Warning {
  Warning(departureLaterBy, arrivalEarlierBy, this.targetDateTimeType) {
    switch (targetDateTimeType) {
      case Input.departure:
        negative = departureLaterBy >= 15 ? departureLaterBy : 0;
        positive = arrivalEarlierBy < 0 ? -arrivalEarlierBy : 0;
        break;
      case Input.arrival:
        negative = arrivalEarlierBy <= -15 ? -arrivalEarlierBy : 0;
        positive = departureLaterBy > 0 ? departureLaterBy : 0;
        break;
    }
  }
  int negative;
  int positive;
  Input targetDateTimeType;
}
