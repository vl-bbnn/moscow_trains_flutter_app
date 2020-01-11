import 'package:flutter/material.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/res/transitcard.dart';

class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({Key key, this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.STATIONCARD_WIDTH,
      height: Constants.STATIONCARD_HEIGHT,
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              station.name,
              overflow: TextOverflow.fade,
              maxLines: 2,
              style: Theme.of(context).textTheme.title,
            ),
            SizedBox(
              height: Constants.PADDING_REGULAR,
            ),
            station.transitList.isNotEmpty
                ? TransitLine(
                    transitList: station.transitList,
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
