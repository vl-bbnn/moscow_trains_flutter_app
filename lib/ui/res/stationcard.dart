import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/ui/res/mycolors.dart';
import 'package:trains/ui/res/stationdetails.dart';

enum StationCardSize { small, regular, big }

class StationCard extends StatelessWidget {
  final Station station;
  final StationCardSize size;
  final bool right;
  final bool selected;
  final double width;

  const StationCard(
      {Key key,
      @required this.station,
      this.width = 0.0,
      @required this.size,
      this.right = false,
      this.selected = false})
      : super(key: key);

  _style(primary) {
    return TextStyle(
        fontFamily: "PT Root UI",
        fontSize: _fontSize(),
        fontWeight: _fontWeight(),
        color: primary ? MyColors.BLACK : MyColors.GREY);
  }

  _fontSize() {
    switch (size) {
      case StationCardSize.small:
        return 12.0;
      case StationCardSize.regular:
        return 16.0;
      case StationCardSize.big:
        return 18.0;
    }
  }

  _textAlign() {
    switch (size) {
      case StationCardSize.small:
        if (right) return TextAlign.end;
        return TextAlign.start;
      case StationCardSize.regular:
        return TextAlign.start;
      case StationCardSize.big:
        return TextAlign.center;
    }
  }

  _fontWeight() {
    if (station.code == "s2006004") return FontWeight.w700;
    return FontWeight.w500;
  }

  _name() {
    return RichText(
      textAlign: _textAlign(),
      text: TextSpan(children: [
        TextSpan(
          text: station.title.toUpperCase(),
          style: _style(true),
        ),
        TextSpan(
          text: station.subtitle.isNotEmpty
              ? "\n" + station.subtitle.toUpperCase()
              : "",
          style: _style(false),
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (size == StationCardSize.small || station.transitList.isEmpty)
      return SizedBox(
        width: width != 0 ? width : null,
        child: _name(),
      );
    if (size == StationCardSize.regular)
      return Row(
        children: <Widget>[
          Expanded(
            child: _name(),
          ),
          SizedBox(
            width: 10,
          ),
          StationDetails(
            transitList: station.transitList,
            big: size == StationCardSize.big,
            stationCode: station.code,
          ),
        ],
      );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        _name(),
        SizedBox(
          height: 15,
        ),
        StationDetails(
          transitList: station.transitList,
          big: size == StationCardSize.big,
          stationCode: station.code,
        ),
      ],
    );
  }
}
