import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/newData/classes/station.dart';
import 'package:trains/newUI/transitcard.dart';

class StationCard extends StatelessWidget {
  final Station station;

  const StationCard({Key key, this.station}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.STATIONCARD_WIDTH,
      height: Constants.STATIONCARD_HEIGHT,
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: Constants.PADDING_BIG,
            vertical: Constants.PADDING_REGULAR),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                child: Text(
                  station.name,
                  overflow: TextOverflow.fade,
                  maxLines: 2,
                  style: Theme.of(context).textTheme.title,
                ),
              ),
              station.subtitle != " "
                  ? Padding(
                      padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                      child: Text(
                        station.subtitle,
                        style: Theme.of(context).textTheme.subtitle,
                      ),
                    )
                  : Container(),
              station.transitList.isNotEmpty
                  ? TransitCard(
                      transit: station.transitList.first,
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
