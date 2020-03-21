import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/res/mycolors.dart';
import 'package:trains/ui/res/stationdetails.dart';

enum StationCardSize { small, regular, big }

class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({@required this.station});

  _fontWeight() {
    if (station.code == "s2006004") return FontWeight.w700;
    return FontWeight.w500;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.6,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          StationDetails(
            transitList: station.transitList,
          ),
          SizedBox(
            height: Helper.height(10, size),
          ),
          Text(
            station.title,
            style: Theme.of(context)
                .textTheme
                .headline2
                .copyWith(fontWeight: _fontWeight()),
          ),
          station.subtitle.isNotEmpty
              ? Column(
                  children: <Widget>[
                    SizedBox(
                      height: Helper.height(10, size),
                    ),
                    Text(
                      station.subtitle,
                      style: Theme.of(context).textTheme.headline2.copyWith(
                          fontSize: 18, color: MyColors.SECONDARY_TEXT),
                    ),
                  ],
                )
              : SizedBox()
        ],
      ),
    );
  }
}
