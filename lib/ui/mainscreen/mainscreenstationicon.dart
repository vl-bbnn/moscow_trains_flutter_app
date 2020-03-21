import 'package:flutter/material.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/res/mycolors.dart';

class MainScreenStationIcon extends StatelessWidget {
  final station;
  final selected;
  final type;
  final notFound;

  const MainScreenStationIcon(
      {Key key, this.station, this.selected, this.type, this.notFound})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (station.transitList.isNotEmpty)
      return Padding(
        padding: const EdgeInsets.all(6),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          decoration: ShapeDecoration(
              shape: CircleBorder(),
              color: notFound ? MyColors.WARNING : MyColors.LENINGRAD),
          width: 24,
          height: 24,
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: ShapeDecoration(
                  shape: CircleBorder(), color: MyColors.PRIMARY_BACKGROUND),
            ),
          ),
        ),
      );
    final top = type == QueryType.departure;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          selected ? 6 : 12, top ? 6 : 18, selected ? 6 : 0, top ? 18 : 6),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: 24,
        height: 12,
        decoration: ShapeDecoration(
            color: notFound ? MyColors.WARNING : MyColors.LENINGRAD,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(selected ? 2 : 6),
                    bottomLeft: Radius.circular(selected ? 2 : 6),
                    topRight: Radius.circular(2),
                    bottomRight: Radius.circular(2)))),
      ),
    );
  }
}
