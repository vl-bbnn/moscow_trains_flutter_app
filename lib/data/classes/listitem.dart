import 'package:trains/data/classes/pause.dart';
import 'package:trains/data/classes/train.dart';

enum ListItemType { train, pause }

class ListItem {
  final ListItemType type;
  final Train train;
  final Pause pause;

  ListItem({this.type, this.train, this.pause});
}
