import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/mainscreen/mainscreentime.dart';
import 'package:trains/ui/res/stationcard.dart';

class MainScreenStation extends StatelessWidget {
  final QueryType type;
  final _stationKey = GlobalKey();

  MainScreenStation({Key key, this.type}) : super(key: key);

  _stream(context) {
    final globalValues = GlobalValues.of(context);
    switch (type) {
      case QueryType.departure:
        return globalValues.searchBloc.fromStation;
      case QueryType.arrival:
        return globalValues.searchBloc.toStation;
    }
  }

  _updateScheme(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed((Duration(milliseconds: 200)), () {
        if (_stationKey.currentContext != null) {
          final globalValues = GlobalValues.of(context);
          final size = MediaQuery.of(context).size;
          final renderBox =
              _stationKey.currentContext.findRenderObject() as RenderBox;
          final topOffset = renderBox.localToGlobal(Offset.zero).dy;
          switch (type) {
            case QueryType.departure:
              final offset = topOffset + renderBox.size.height / 2;
              globalValues.schemeBloc.updateTop(offset);
              break;
            case QueryType.arrival:
              final offset =
                  size.height - topOffset - renderBox.size.height / 2;
              globalValues.schemeBloc.updateBottom(offset);
              break;
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return StreamBuilder<Station>(
        stream: _stream(context),
        builder: (context, fromStream) {
          if (!fromStream.hasData) return Container();
          _updateScheme(context);
          switch (type) {
            case QueryType.departure:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    key: _stationKey,
                    child: StationCard(
                      station: fromStream.data,
                    ),
                  ),
                  SizedBox(
                    height: Helper.height(30, size),
                  ),
                  MainScreenTime(
                    type: type,
                  ),
                ],
              );
            case QueryType.arrival:
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  MainScreenTime(
                    type: type,
                  ),
                  SizedBox(
                    height: Helper.height(30, size),
                  ),
                  Container(
                    key: _stationKey,
                    child: StationCard(
                      station: fromStream.data,
                    ),
                  ),
                ],
              );
          }
          return Container();
        });
  }
}
