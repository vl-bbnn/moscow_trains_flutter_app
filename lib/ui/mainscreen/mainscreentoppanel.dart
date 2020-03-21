import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/res/datetext.dart';
import 'package:trains/ui/res/roundicon.dart';

class MainScreenTopPanel extends StatelessWidget {
  final _panelKey = GlobalKey();

  _updateScheme(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (_panelKey.currentContext != null) {
          final globalValues = GlobalValues.of(context);
          final renderBox =
              _panelKey.currentContext.findRenderObject() as RenderBox;
          globalValues.schemeBloc.updateTopOffset(renderBox.size.height);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    final padding = MediaQuery.of(context).padding;
    final size = MediaQuery.of(context).size;
    _updateScheme(context);
    return StreamBuilder<Status>(
        stream: globalValues.searchBloc.status,
        builder: (context, statusStream) {
          if (!statusStream.hasData) return Container();
          return Container(
            padding: EdgeInsets.fromLTRB(
                Helper.width(25, size),
                Helper.height(padding.top + 10, size),
                Helper.width(25, size),
                Helper.height(30, size)),
            key: _panelKey,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    RoundIcon(
                      type: Type.calendar,
                    ),
                    SizedBox(
                      width: Helper.width(20, size),
                    ),
                    StreamBuilder<DateTime>(
                        stream: globalValues.searchBloc.dateTime,
                        builder: (context, dateTimeStream) {
                          if (!dateTimeStream.hasData) return Container();
                          return DateText(
                            date: dateTimeStream.data,
                          );
                        }),
                  ],
                ),
                Row(
                  children: <Widget>[
                    RoundIcon(
                      type: Type.share,
                    ),
                    SizedBox(
                      width: Helper.width(20, size),
                    ),
                    RoundIcon(
                      type: Type.bookmark_selected,
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }
}
