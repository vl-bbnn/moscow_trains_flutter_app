import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/res/transitcard.dart';

class StationCard extends StatelessWidget {
  final Station station;
  final bool small;
  final bool right;
  final bool selected;

  const StationCard(
      {Key key,
      this.station,
      this.small = false,
      this.right = false,
      this.selected = false})
      : super(key: key);

  _style() {
    return TextStyle(
        fontFamily: "PT Root UI",
        fontWeight:
            station.code == "s2006004" ? FontWeight.w700 : FontWeight.w500);
  }

  @override
  Widget build(BuildContext context) {
    if (small)
      return Container(
        width: Constants.STATIONCARD_WIDTH_SMALL,
        child: Column(
          crossAxisAlignment:
              right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              station.title.toUpperCase(),
              textAlign: right ? TextAlign.end : TextAlign.start,
              overflow: TextOverflow.fade,
              maxLines: 2,
              style: _style().copyWith(
                  fontSize: 12.0,
                  color: selected ? Constants.WHITE : Constants.GREY),
            ),
            station.subtitle.isNotEmpty
                ? Text(
                    station.subtitle.toUpperCase(),
                    textAlign: right ? TextAlign.end : TextAlign.start,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: _style()
                        .copyWith(fontSize: 12.0, color: Constants.GREY),
                  )
                : Container(),
          ],
        ),
      );
    return Container(
      width: Constants.STATIONCARD_WIDTH_REGULAR,
      height: Constants.STATIONCARD_HEIGHT,
      decoration: ShapeDecoration(
          color: selected ? Constants.ELEVATED_2 : Colors.transparent,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: Constants.ELEVATED_2, width: 2))),
      padding: const EdgeInsets.all(13),
      child: Center(
        child: SizedBox(
          height: 59,
          width: 120,
          child: Column(
            crossAxisAlignment:
                right ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                station.title.toUpperCase(),
                textAlign: right ? TextAlign.end : TextAlign.start,
                overflow: TextOverflow.fade,
                maxLines: 2,
                style:
                    _style().copyWith(fontSize: 14.0, color: Constants.WHITE),
              ),
              station.subtitle.isNotEmpty
                  ? Text(
                      station.subtitle.toUpperCase(),
                      textAlign: right ? TextAlign.end : TextAlign.start,
                      overflow: TextOverflow.fade,
                      maxLines: 1,
                      style: _style()
                          .copyWith(fontSize: 14.0, color: Constants.GREY),
                    )
                  : Container(),
              station.transitList.isNotEmpty
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: 5,
                        ),
                        TransitLine(
                            transitList: station.transitList, right: right),
                      ],
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }
}
