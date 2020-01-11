import 'package:trains/data/src/helper.dart';

class Warning {
  Warning(DateTime fact, DateTime target) {
    diff = Helper.timeDiffInMins(fact, target);
  }
  int diff;
}
