import 'package:flutter/material.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/timetext.dart';

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
          height: 14,
          width: 14,
          child: _icon(line),
        );
      case "d2":
      case "d3":
      case "kazan":
      case "yaroslavl":
      case "leningrad":
      case "kursk":
        return SizedBox(
          height: 9,
          width: 18,
          child: _icon(line),
        );
      default:
        return Container(
          height: 14,
          width: 14,
          color: MyColors.WA,
        );
    }
  }

  _icon(line) {
    switch (line) {
      case "m1":
        return Image.asset(
          'assets/types/m1.png',
        );
      case "m5":
        return Image.asset(
          'assets/types/m5.png',
        );
      case "m9":
        return Image.asset(
          'assets/types/m9.png',
        );
      case "m10":
        return Image.asset(
          'assets/types/m10.png',
        );
      case "m14":
        return Image.asset(
          'assets/types/m14.png',
        );
      case "d2":
        return Image.asset(
          'assets/types/d2.png',
        );
      case "d3":
        return Image.asset(
          'assets/types/d3.png',
        );
      case "kursk":
        return Image.asset(
          'assets/types/ku.png',
        );
      case "yaroslavl":
        return Image.asset(
          'assets/types/ya.png',
        );
      case "kazan":
        return Image.asset(
          'assets/types/ka.png',
        );
      case "leningrad":
        return Image.asset(
          'assets/types/le.png',
        );
      default:
        return Image.asset(
          'assets/types/d3.png',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Row(
      children: transitList.map((transit) {
        final lines = transit['lines'] as List;
        final time = transit['time'] as int;
        if (lines == null) return Container();
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                ? TimeText(
                    width: Helper.width(45, size),
                    textAlign: TextAlign.start,
                    align: Alignment.centerLeft,
                    time: time,
                    shouldWarn: time > 10,
                    short: true,
                  )
                : Container(),
          ],
        );
      }).toList(),
    );
  }
}
