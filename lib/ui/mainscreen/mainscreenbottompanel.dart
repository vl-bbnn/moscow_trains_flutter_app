import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/mainscreen/mainscreenmessage.dart';
import 'package:trains/ui/mainscreen/mainscreentrainselector.dart';

class MainScreenBottomPanel extends StatelessWidget {
  final _panelKey = GlobalKey();

  _updateScheme(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (_panelKey.currentContext != null) {
          final globalValues = GlobalValues.of(context);
          final renderBox =
              _panelKey.currentContext.findRenderObject() as RenderBox;
          globalValues.schemeBloc.updateBottomOffset(renderBox.size.height);
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
            key: _panelKey,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: Helper.height(25, size),
                ),
                if (statusStream.data == Status.found)
                  MainScreenTrainSelector()
                else
                  MainScreenMessage(
                    status: statusStream.data,
                  ),
                SizedBox(
                  height: padding.bottom + Helper.height(20, size),
                ),
              ],
            ),
          );
        });
  }
}
