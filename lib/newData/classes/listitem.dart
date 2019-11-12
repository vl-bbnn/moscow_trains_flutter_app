import 'package:trains/newData/classes/warning.dart';
import 'package:trains/newData/classes/train.dart';

enum ListItemType { train, warning }

class ListItem {
  final ListItemType type;
  final Train train;
  final Warning warning;

  ListItem({this.type, this.train, this.warning});
}
