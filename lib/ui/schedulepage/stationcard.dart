import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/appnavigationbloc.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/stationdetails.dart';

class StationCard extends StatelessWidget {
  final QueryType type;
  final Station station;

  StationCard({Key key, this.type, this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalBloc.of(context);
    final textBloc = globalValues.textBloc;
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        globalValues.searchBloc.stationType.add(type);
        globalValues.appNavigationBloc.nextAppState.add(AppState.StationSelect);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          StationDetails(
            transitList: station.transitList,
          ),
          SizedBox(
            height: Helper.height(10, size),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                width: size.width * 0.4,
                color: textBloc.showTextBorders ? Colors.red : null,
                child: AutoSizeText(
                  station.title,
                  maxLines: 2,
                  group: textBloc.stationTitle,
                  style: Theme.of(context).textTheme.headline2.copyWith(
                      fontWeight:
                          station.terminal ? FontWeight.w700 : FontWeight.w500),
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
                          color: textBloc.showTextBorders ? Colors.red : null,
                          child: AutoSizeText(
                            station.subtitle,
                            maxLines: 1,
                            group: textBloc.stationSubtitle,
                            style: Theme.of(context)
                                .textTheme
                                .headline2
                                .copyWith(
                                    fontSize: 14, color: MyColors.TEXT_SE),
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
  }
}
