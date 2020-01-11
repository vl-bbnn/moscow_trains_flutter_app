import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/data/src/my_transit_icons.dart';
import 'package:trains/data/src/my_types_icons.dart';

class TransitLine extends StatelessWidget {
  final List<Map<String, Object>> transitList;

  const TransitLine({Key key, this.transitList}) : super(key: key);

  _metroColor(line) {
    switch (line) {
      case "1":
        return Constants.METRO1;
      case "5":
        return Constants.METRO5;
      case "9":
        return Constants.METRO9;
      case "10":
        return Constants.METRO10;
      default:
        return Constants.BLACK;
    }
  }

  _metroLine(line, context) {
    final mcd = line == "14";
    return Container(
      decoration: ShapeDecoration(
          color: mcd ? Colors.transparent : _metroColor(line),
          shape: CircleBorder(
              side: mcd
                  ? BorderSide(color: Constants.METRO14, width: 2)
                  : BorderSide.none)),
      width: 30.0,
      child: Center(
        child: Text(
          line,
          style: Theme.of(context)
              .textTheme
              .subtitle
              .copyWith(color: mcd ? Constants.WHITE : Constants.BLACK),
        ),
      ),
    );
  }

  _icon(line, context) {
    switch (line) {
      case "1":
      case "5":
      case "9":
      case "10":
      case "14":
        return _metroLine(line, context);
      case "d2":
        return Container(
          width: 48,
          child: Icon(
            MyTransit.d2,
            color: Constants.D2,
            size: 24,
          ),
        );
      case "kursk":
        return Container(
          width: 24,
          child: Text(
            "Ку",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Constants.KURSK),
          ),
        );
      case "yaroslav":
        return Container(
          width: 24,
          child: Text(
            "Яр",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Constants.YAROSLAVL),
          ),
        );
      case "kazan":
        return Container(
          width: 24,
          child: Text(
            "Ка",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Constants.KAZAN),
          ),
        );
      case "leningrad":
        return Container(
          width: 24,
          child: Text(
            "Ле",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(color: Constants.LENINGRAD),
          ),
        );
      default:
        return Constants.BLACK;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: Row(
        children: transitList
            .map((transit) => Row(
                  children: <Widget>[
                    _icon(transit['line'], context),
                    transitList.length < 3
                        ? Row(
                            children: <Widget>[
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                Helper.minutesToText(
                                    transit['time'])['shortText'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subhead
                                    .copyWith(fontSize: 14),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          )
                        : SizedBox(width: 5),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
