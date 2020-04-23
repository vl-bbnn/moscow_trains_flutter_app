import 'package:flutter/material.dart';
import 'package:trains/ui/common/mycolors.dart';

enum Type { arrows, people, bookmarks }

class CustomIcon extends StatelessWidget {
  final Type type;
  final double size;

  const CustomIcon({Key key, this.type, this.size = 36.0})
      : assert(type != null);

  _customIcon() {
    switch (type) {
      case Type.arrows:
        return Stack(
          children: <Widget>[
            Image.asset(
              'assets/icons/bidirectional_arrow-secondary.png',
              color: MyColors.TEXT_SE,
            ),
            Image.asset(
              'assets/icons/bidirectional_arrow-primary.png',
              color: MyColors.TEXT_PR,
            ),
          ],
        );
      case Type.people:
        return Stack(
          children: <Widget>[
            Image.asset(
              'assets/icons/group-secondary.png',
              color: MyColors.TEXT_SE,
            ),
            Image.asset(
              'assets/icons/group-primary.png',
              color: MyColors.TEXT_PR,
            ),
          ],
        );
      case Type.bookmarks:
        return Stack(
          children: <Widget>[
            Image.asset(
              'assets/icons/bookmarks-secondary.png',
              color: MyColors.TEXT_SE,
            ),
            Image.asset(
              'assets/icons/bookmarks-primary.png',
              color: MyColors.TEXT_PR,
            ),
          ],
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: _customIcon(),
    );
  }
}
