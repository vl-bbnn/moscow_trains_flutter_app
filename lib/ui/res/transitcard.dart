import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class TransitLine extends StatelessWidget {
  final List<Map<String, Object>> transitList;
  final bool right;
  const TransitLine({Key key, this.transitList, this.right}) : super(key: key);

  _shape(line) {
    switch (line) {
      case "1":
      case "5":
      case "9":
      case "10":
      case "14":
        return Row(
          children: <Widget>[
            SizedBox(
              height: 18,
              width: 18,
              child: _icon(line),
            ),
            SizedBox(
              width: 3,
            ),
          ],
        );
      case "d2":
      case "d3":
      case "kazan":
      case "yaroslav":
      case "leningrad":
      case "kursk":
        return SizedBox(
          height: 12,
          width: 24,
          child: _icon(line),
        );
      default:
        return Container(
          height: 12,
          width: 12,
          color: Constants.WARNING,
        );
    }
  }

  _icon(line) {
    switch (line) {
      case "1":
        return SvgPicture.asset(
          'assets/transitLines/m1.svg',
          semanticsLabel: 'm1',
          color: Constants.METRO1,
        );
      case "5":
        return SvgPicture.asset(
          'assets/transitLines/m5.svg',
          semanticsLabel: 'm5',
          color: Constants.METRO5,
        );
      case "9":
        return SvgPicture.asset(
          'assets/transitLines/m9.svg',
          semanticsLabel: 'm9',
          color: Constants.METRO9,
        );
      case "10":
        return SvgPicture.asset(
          'assets/transitLines/m10.svg',
          semanticsLabel: 'm10',
          color: Constants.METRO10,
        );
      case "14":
        return Stack(
          children: <Widget>[
            SvgPicture.asset(
              'assets/transitLines/m14-back.svg',
              semanticsLabel: 'm14-back',
              color: Constants.METRO14,
            ),
            Center(
              child: SvgPicture.asset(
                'assets/transitLines/m14-fore.svg',
                semanticsLabel: 'm14-fore',
                color: Constants.WHITE,
              ),
            ),
          ],
        );
      case "d2":
        return SvgPicture.asset(
          'assets/trainClasses/d2.svg',
          semanticsLabel: 'd2',
          color: Constants.D2,
        );
      case "d3":
        return SvgPicture.asset(
          'assets/trainClasses/d3.svg',
          semanticsLabel: 'd3',
          color: Constants.D3,
        );
      case "kursk":
        return SvgPicture.asset(
          'assets/transitLines/ku.svg',
          semanticsLabel: 'ku',
          color: Constants.KURSK,
        );
      case "yaroslav":
        return SvgPicture.asset(
          'assets/transitLines/ya.svg',
          semanticsLabel: 'ya',
          color: Constants.YAROSLAVL,
        );
      case "kazan":
        return SvgPicture.asset(
          'assets/transitLines/ka.svg',
          semanticsLabel: 'ka',
          color: Constants.KAZAN,
        );
      case "leningrad":
        return SvgPicture.asset(
          'assets/transitLines/le.svg',
          semanticsLabel: 'le',
          color: Constants.LENINGRAD,
        );
      default:
        return SvgPicture.asset(
          'assets/transitLines/d3.svg',
          semanticsLabel: 'd3-white',
          color: Constants.WHITE,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 18,
      child: Row(
        mainAxisAlignment:
            right ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: transitList
            .map((transit) => Row(
                  children: <Widget>[
                    _shape(transit['line']),
                    transitList.length < 3
                        ? Row(
                            children: <Widget>[
                              Text(
                                Helper.minutesToText(
                                    transit['time'])['shortText'],
                                style: Theme.of(context)
                                    .textTheme
                                    .subtitle1
                                    .copyWith(fontSize: 10),
                              ),
                              SizedBox(
                                width: 3,
                              ),
                            ],
                          )
                        : SizedBox(),
                  ],
                ))
            .toList(),
      ),
    );
  }
}
