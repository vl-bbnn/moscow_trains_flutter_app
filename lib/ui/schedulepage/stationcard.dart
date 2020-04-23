import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/appnavigationbloc.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/stationdetails.dart';

class StationCard extends StatelessWidget {
  final QueryType type;

  StationCard({Key key, this.type}) : super(key: key);

  _fontWeight(code) {
    if (code == "s2006004") return FontWeight.w700;
    return FontWeight.w500;
  }

  _stream(context) {
    final globalValues = GlobalValues.of(context);
    switch (type) {
      case QueryType.departure:
        return globalValues.searchBloc.fromStation;
      case QueryType.arrival:
        return globalValues.searchBloc.toStation;
    }
  }

  @override
  Widget build(BuildContext context) {
    final stream = _stream(context);
    final globalValues = GlobalValues.of(context);
    final textBloc = globalValues.textBloc;
    final size = MediaQuery.of(context).size;
    return StreamBuilder<Station>(
        stream: stream,
        builder: (context, fromStream) {
          if (!fromStream.hasData) return Container();
          final station = fromStream.data;
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTap: () {
              globalValues.searchBloc.stationType.add(type);
              globalValues.appNavigationBloc
                  .nextAppState.add(AppState.StationSelect);
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                StationDetails(
                  transitList: station.transitList,
                ),
                SizedBox(
                  height: Helper.height(10, size),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: size.width * 0.4,
                      color: textBloc.showTextBorders ? Colors.red : null,
                      child: AutoSizeText(
                        station.title,
                        maxLines: 2,
                        group: textBloc.stationTitle,
                        style: Theme.of(context)
                            .textTheme
                            .headline2
                            .copyWith(fontWeight: _fontWeight(station.code)),
                      ),
                    ),
                    station.subtitle.isNotEmpty
                        ? Column(
                            children: <Widget>[
                              SizedBox(
                                height: Helper.height(5, size),
                              ),
                              Container(
                                width: size.width * 0.4,
                                color: textBloc.showTextBorders
                                    ? Colors.red
                                    : null,
                                child: AutoSizeText(
                                  station.subtitle,
                                  maxLines: 1,
                                  group: textBloc.stationSubtitle,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline2
                                      .copyWith(
                                          fontSize: 14,
                                          color: MyColors.TEXT_SE),
                                ),
                              ),
                            ],
                          )
                        : SizedBox()
                  ],
                ),
              ],
            ),
          );
        });
  }
}
