import 'dart:async';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/uibloc.dart';
import 'package:trains/data/classes/listitem.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/frontpanel/category/list/item/categorylistItem.dart';

class ItemsList extends StatefulWidget {
  ItemsList({@required this.list, @required this.scrollController});

  final List<ListItem> list;
  final ScrollController scrollController;

  @override
  _ItemsListState createState() => _ItemsListState();
}

class _ItemsListState extends State<ItemsList> {
  DateTime scrolledTime = DateTime.now();

  bool _scrollAnchor() {
    var offset = widget.scrollController.offset;
    if (offset >= widget.scrollController.position.maxScrollExtent)
      return false;
    var index = (offset / (Constants.CATEGORY_TRAIN_SIZE + 8.0)).round();
    if (widget.list.elementAt(index).type == ListItemType.pause) index += 1;
    _scrollToSelected(index);
    return false;
  }

  _scrollToSelected(int index) {
    var offset = index * (Constants.CATEGORY_TRAIN_SIZE + 8.0);
    Future.delayed(const Duration(milliseconds: 20), () {}).then((s) {
      widget.scrollController.animateTo(offset,
          duration: Duration(milliseconds: 200), curve: Curves.easeIn);
    });
    scrolledTime = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    final uiBloc = InheritedBloc.uiOf(context);
    return Container(
        height:
            Constants.CATEGORY_TRAIN_SIZE + Constants.CATEGORY_TRAIN_PADDING,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollEndNotification &&
                DateTime.now().difference(scrolledTime).inMilliseconds > 500)
              _scrollAnchor();
            return false;
          },
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.list.length,
              controller: widget.scrollController,
              itemBuilder: (context, index) {
                var item = widget.list.elementAt(index);
                return Row(
                  children: <Widget>[
                    Container(
                      width: index == 0
                          ? 18.0 + Constants.CATEGORY_TRAIN_PADDING
                          : 0.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        if (item.type == ListItemType.train) {
                          trainsBloc.updateThread(item.train.uid);
                          uiBloc.backPanelTypeSink.add(BackPanelType.thread);
                          _scrollToSelected(index);
                          uiBloc.frontPanelOpenSink.add(false);
                        }
                      },
                      child: CategoryListItem(
                        item: item,
                      ),
                    ),
                    Container(
                      width: index == widget.list.length - 1
                          ? 18.0 + Constants.CATEGORY_TRAIN_PADDING
                          : 0.0,
                    ),
                  ],
                );
              }),
        ));
  }
}
