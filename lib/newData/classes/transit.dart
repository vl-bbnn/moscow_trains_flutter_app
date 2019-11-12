import 'package:flutter/widgets.dart';

class Transit {
  String name;
  bool accessible;
  List<int> times;
  List<int> lines;

  Transit({@required Map<dynamic, dynamic> map}) {
    this.accessible = map["accessible"] ?? false;
    this.name = map["name"];
    this.times = List.from(map["times"]);
    this.lines = List.from(map["lines"]);
  }
}
