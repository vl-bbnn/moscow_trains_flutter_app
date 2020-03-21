import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trains/ui/res/mycolors.dart';

enum Type { calendar, share, bookmark_selected, bookmark_deselected }

class RoundIcon extends StatelessWidget {
  final Type type;
  final double size;

  const RoundIcon({Key key, this.type, this.size = 36.0})
      : assert(type != null);

  _regularIcon() {
    switch (type) {
      case Type.calendar:
        return Icons.calendar_today;
      case Type.bookmark_selected:
        return Icons.bookmark;
      case Type.bookmark_deselected:
        return Icons.bookmark_border;
      default:
        return Icons.error;
    }
  }

  _customIcon() {
    switch (type) {
      case Type.share:
        return SvgPicture.asset(
          'assets/icons/share-ios.svg',
          semanticsLabel: 'share',
          color: MyColors.PRIMARY_TEXT,
        );
      default:
        return SvgPicture.asset(
          'assets/icons/share-ios.svg',
          semanticsLabel: 'error',
          color: MyColors.WARNING,
        );
    }
  }

  _icon() {
    switch (type) {
      case Type.calendar:
      case Type.bookmark_selected:
      case Type.bookmark_deselected:
        return Icon(
          _regularIcon(),
          size: size / 2,
          color: MyColors.PRIMARY_TEXT,
        );
      case Type.share:
        return SizedBox(
          width: size / 2,
          height: size / 2,
          child: _customIcon(),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: ShapeDecoration(
          shape: CircleBorder(), color: MyColors.SECONDARY_BACKGROUND),
      child: Center(
        child: _icon(),
      ),
    );
  }
}
