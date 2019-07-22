import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/listitem.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/frontpanel/category/background/categorybackground.dart';
import 'package:trains/ui/frontpanel/category/categoriesdivider.dart';
import 'package:trains/ui/frontpanel/category/list/categoryitemslist.dart';

class Category extends StatefulWidget {
  Category(this.type);

  final TrainType type;

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  TrainsBloc trainsBloc;

  @override
  void initState() {
    super.initState();
  }

  Stream<List<ListItem>> _stream() {
    switch (widget.type) {
      case TrainType.suburban:
        {
          return trainsBloc.regularListItemsStream;
        }
      case TrainType.lastm:
        {
          return trainsBloc.comfortListItemsStream;
        }
      case TrainType.last:
        {
          return trainsBloc.expressListItemsStream;
        }
      default:
        {
          return null;
        }
    }
  }

  @override
  Widget build(BuildContext context) {
    trainsBloc = InheritedBloc.trainsOf(context);
    final ScrollController scrollController = new ScrollController();
    return StreamBuilder<List<ListItem>>(
      stream: _stream(),
      builder: (context, snapshot) {
        var list = snapshot.data;
        if (list == null || list.length == 0) return Container();
        List<Train> sublist = new List();
        list
            .sublist(0, math.min(8, list.length))
            .where((item) => item.type == ListItemType.train)
            .forEach((item) {
          if (sublist.length < 4) sublist.add(item.train);
        });
        return Stack(
          children: <Widget>[
            CategoryBackground(
              type: widget.type,
              sublist: sublist,
              scrollController: scrollController,
            ),
            Positioned(
              bottom: Constants.CATEGORY_TRAIN_PADDING + 8.0,
              left: 0.0,
              right: 0.0,
              child: ItemsList(
                list: list,
                scrollController: scrollController,
              ),
            )
          ],
        );
      },
    );
  }
}
