import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/res/mycolors.dart';

class StationDetails extends StatelessWidget {
  final List<Map<String, Object>> transitList;
  const StationDetails({Key key, this.transitList}) : super(key: key);

  Widget _shape(line) {
    switch (line) {
      case "m1":
      case "m5":
      case "m9":
      case "m10":
      case "m14":
        return SizedBox(
          height: 18,
          width: 18,
          child: _icon(line),
        );
      case "d2":
      case "d3":
      case "kazan":
      case "yaroslavl":
      case "leningrad":
      case "kursk":
        return SizedBox(
          height: 12,
          width: 24,
          child: _icon(line),
        );
      default:
        return Container(
          height: 18,
          width: 18,
          color: MyColors.WARNING,
        );
    }
  }

  _icon(line) {
    switch (line) {
      case "m1":
        return SvgPicture.asset(
          'assets/types/m1.svg',
          semanticsLabel: 'm1',
          color: MyColors.METRO1,
        );
      case "m5":
        return SvgPicture.asset(
          'assets/types/m5.svg',
          semanticsLabel: 'm5',
          color: MyColors.METRO5,
        );
      case "m9":
        return SvgPicture.asset(
          'assets/types/m9.svg',
          semanticsLabel: 'm9',
          color: MyColors.METRO9,
        );
      case "m10":
        return SvgPicture.asset(
          'assets/types/m10.svg',
          semanticsLabel: 'm10',
          color: MyColors.METRO10,
        );
      case "m14":
        return Stack(
          children: <Widget>[
            SvgPicture.asset(
              'assets/types/m14-back.svg',
              semanticsLabel: 'm14-back',
              color: MyColors.METRO14,
            ),
            Center(
              child: SizedBox(
                width: 14.93,
                height: 11.2,
                child: SvgPicture.asset(
                  'assets/types/m14-fore.svg',
                  semanticsLabel: 'm14-fore',
                  color: MyColors.PRIMARY_BACKGROUND,
                ),
              ),
            ),
          ],
        );
      case "d2":
        return SvgPicture.asset(
          'assets/types/d2.svg',
          semanticsLabel: 'd2',
          color: MyColors.D2,
        );
      case "d3":
        return SvgPicture.asset(
          'assets/types/d3.svg',
          semanticsLabel: 'd3',
          color: MyColors.D3,
        );
      case "kursk":
        return SvgPicture.asset(
          'assets/types/ku.svg',
          semanticsLabel: 'ku',
          color: MyColors.KURSK,
        );
      case "yaroslavl":
        return SvgPicture.asset(
          'assets/types/yr.svg',
          semanticsLabel: 'ya',
          color: MyColors.YAROSLAVL,
        );
      case "kazan":
        return SvgPicture.asset(
          'assets/types/ka.svg',
          semanticsLabel: 'ka',
          color: MyColors.KAZAN,
        );
      case "leningrad":
        return SvgPicture.asset(
          'assets/types/le.svg',
          semanticsLabel: 'le',
          color: MyColors.LENINGRAD,
        );
      default:
        return SvgPicture.asset(
          'assets/types/d3.svg',
          semanticsLabel: 'd3-white',
          color: MyColors.PRIMARY_BACKGROUND,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: transitList.map((transit) {
        final lines = transit['lines'] as List;
        if (lines == null) return Container();
        return Row(
          children: <Widget>[
            Row(
              children: lines.map((line) {
                return Row(
                  children: <Widget>[
                    _shape(line),
                    SizedBox(
                      width: Helper.width(5, size),
                    ),
                  ],
                );
              }).toList(),
            ),
            transitList.length < 3
                ? Row(
                    children: <Widget>[
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        Helper.minutesToText(transit['time'])['shortText'],
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ],
                  )
                : Container(),
          ],
        );
      }).toList(),
    );
  }
}
