import 'package:trains/data/classes/train.dart';
import 'package:trains/data/classes/warning.dart';

enum ListItemType { train, warning }

class ListItem {
  final ListItemType type;
  final Train train;
  final Warning warning;

  ListItem({this.type, this.train, this.warning});
}
