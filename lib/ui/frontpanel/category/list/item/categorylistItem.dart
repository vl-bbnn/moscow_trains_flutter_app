import 'package:flutter/material.dart';
import 'package:trains/data/classes/listitem.dart';
import 'package:trains/ui/frontpanel/category/list/item/categorytrain.dart';
import 'package:trains/ui/frontpanel/category/list/item/pausewarning.dart';

class CategoryListItem extends StatelessWidget {
  final ListItem item;
  const CategoryListItem({Key key, this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (item.type) {
      case ListItemType.train:
        {
          if (item.train == null) return Container();
          return CategoryTrain(train: item.train);
        }
      case ListItemType.pause:
        {
          if (item.pause == null) return Container();
          return PauseWarning(pause: item.pause);
        }
      default:
        return Container();
    }
  }
}
