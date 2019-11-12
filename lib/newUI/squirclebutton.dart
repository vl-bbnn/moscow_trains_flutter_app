import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/my_icons_icons.dart';

enum ButtonType {
  Search,
  Back,
  Close,
  Save,
  Prev,
  Next,
  NotificationsOn,
  NotificationsOff,
  Share,
  Departure,
  Arrival,
  Reset
}

class SquircleButton extends StatelessWidget {
  final ButtonType type;
  final bool enabled;
  final bool raised;
  final bool fab;
  final bool top;
  final Function() callback;
  const SquircleButton(
      {Key key,
      @required this.type,
      @required this.top,
      @required this.enabled,
      @required this.raised,
      @required this.fab,
      @required this.callback})
      : super(key: key);

  Color _iconColor() {
    if (fab) return Constants.BLACK;
    if (raised || !enabled) return Constants.GREY;
    return Constants.PRIMARY;
  }

  Color _backgroundColor() {
    if (fab) return Constants.PRIMARY;
    if (raised) return Constants.SECONDARY;
    return Colors.transparent;
  }

  IconData _iconData() {
    switch (type) {
      case ButtonType.Search:
        return Icons.search;
      case ButtonType.Back:
        return Icons.arrow_back;
      case ButtonType.Close:
        return Icons.close;
      case ButtonType.Save:
        return Icons.done;
      case ButtonType.Prev:
        return Icons.arrow_back_ios;
      case ButtonType.Next:
        return Icons.arrow_forward_ios;
      case ButtonType.NotificationsOn:
        return Icons.notifications_active;
      case ButtonType.Share:
        return Icons.share;
      case ButtonType.NotificationsOff:
        return Icons.notifications_off;
      case ButtonType.Departure:
        return MyIcons.departure;
      case ButtonType.Arrival:
        return MyIcons.arrival;
      case ButtonType.Reset:
        return Icons.settings_backup_restore;
    }
    return Icons.error;
  }

  @override
  Widget build(BuildContext context) {
    final radius = Radius.circular(38.5);
    return GestureDetector(
      onTap: callback,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 125,
        width: 100,
        child: Material(
          color: _backgroundColor(),
          elevation: fab || raised ? 8.0 : 0.0,
          shadowColor: Constants.SHADE,
          shape: RoundedRectangleBorder(
              borderRadius: top
                  ? BorderRadius.only(topRight: radius, bottomLeft: radius)
                  : BorderRadius.only(topLeft: radius, bottomRight: radius)),
          child: Padding(
            padding: EdgeInsets.only(
                top: top ? Constants.PADDING_REGULAR : 0,
                bottom: !top ? Constants.PADDING_REGULAR : 0),
            child: Center(
              child: Icon(
                _iconData(),
                color: _iconColor(),
                size: 36,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
