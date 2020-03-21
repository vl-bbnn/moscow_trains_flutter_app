import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/res/mycolors.dart';
import 'package:trains/ui/res/timetext.dart';
import 'package:trains/ui/res/trainclasslogo.dart';

class MainScreenTrainSelector extends StatelessWidget {
  List<double> _stops(size) {
    final left = (Helper.width(75, size) + 24) / size.width;
    final right = 1 - left;
    return ([0, left - 0.001, left, right, right + 0.001, 1.0]);
  }

  Color _color(TrainClass type) {
    switch (type) {
      case TrainClass.regular:
        return MyColors.REGULAR;
      case TrainClass.comfort:
        return MyColors.COMFORT;
      case TrainClass.express:
        return MyColors.EXPRESS;
      default:
        return MyColors.PRIMARY_BACKGROUND;
    }
  }

  Widget _trainIcon(type, selected) {
    if (selected)
      return Stack(
        children: <Widget>[
          SizedBox(
            height: 24,
            width: 48,
            child: SvgPicture.asset(
              'assets/types/back.svg',
              semanticsLabel: 'back',
              color: MyColors.PRIMARY_BACKGROUND,
            ),
          ),
          TrainClassLogo(
            trainClass: type,
          ),
        ],
      );
    else
      return SizedBox(
        width: 36,
        height: 18,
        child: Stack(
          children: <Widget>[
            SvgPicture.asset(
              'assets/types/back.svg',
              semanticsLabel: 'back',
              color: _color(type),
            ),
            TrainClassLogo(
              trainClass: type,
              colored: false,
              width: 36,
            ),
            SvgPicture.asset(
              'assets/types/form.svg',
              semanticsLabel: 'form',
              color: _color(type),
            )
          ],
        ),
      );
  }

  Map<String, TrainClass> _map(List<Train> list, int selectedIndex) {
    final hasTrainsOnRight = (list.length - 1 - selectedIndex) > 1;
    final hasTrainsOnLeft = selectedIndex > 1;
    final selectedLast = selectedIndex == list.length - 1;
    var prevClass;
    var leftClass;
    var rightClass;
    var nextClass;
    if (list.length > 1) {
      final leftIndex = !selectedLast ? selectedIndex : selectedIndex - 1;
      final rightIndex = !selectedLast ? selectedIndex + 1 : selectedIndex;
      leftClass = list.elementAt(leftIndex).trainClass;
      rightClass = list.elementAt(rightIndex).trainClass;
      if (hasTrainsOnLeft) prevClass = list.elementAt(leftIndex - 1).trainClass;
      if (hasTrainsOnRight)
        nextClass = list.elementAt(rightIndex + 1).trainClass;
    } else {
      leftClass = list.first.trainClass;
    }
    return {
      'prev': prevClass,
      'nearLeft': hasTrainsOnLeft ? leftClass : null,
      'left': leftClass,
      'right': rightClass,
      'nearRight': hasTrainsOnRight ? rightClass : null,
      'next': nextClass,
    };
  }

  _breakText(context, List<Train> list, int selectedIndex) {
    if (list.length > 1) {
      final selectedLast = selectedIndex == list.length - 1;
      final leftIndex = !selectedLast ? selectedIndex : selectedIndex - 1;
      final rightIndex = !selectedLast ? selectedIndex + 1 : selectedIndex;
      final minutes = Helper.timeDiffInMins(list.elementAt(leftIndex).departure,
          list.elementAt(rightIndex).departure);
      if (minutes == 0)
        return Text(
          "в то же время".toUpperCase(),
          style: Theme.of(context).textTheme.headline1,
        );
      final text = Helper.minutesToText(minutes);
      return TimeText(
        text: text,
        warn: minutes > 15,
      );
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    final size = MediaQuery.of(context).size;
    return StreamBuilder<List<Train>>(
        stream: globalValues.trainsBloc.results,
        builder: (context, resultsStream) {
          return StreamBuilder<int>(
              stream: globalValues.trainsBloc.index,
              builder: (context, selectedIndexStream) {
                if (!resultsStream.hasData || !selectedIndexStream.hasData)
                  return Container();
                final selectedIndex = selectedIndexStream.data;
                final selectedLast =
                    selectedIndexStream.data == resultsStream.data.length - 1;
                final map = _map(resultsStream.data, selectedIndexStream.data);
                final stops = _stops(size);
                final colors =
                    map.values.map((trainClass) => _color(trainClass)).toList();
                return Column(
                  children: <Widget>[
                    Center(
                        child: _breakText(
                            context, resultsStream.data, selectedIndex)),
                    Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Container(
                            width: size.width,
                            height: 2,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(
                                    colors: colors, stops: stops)),
                          ),
                        ),
                        Center(
                          child: Row(
                            children: <Widget>[
                              SizedBox(
                                width: Helper.width(75, size),
                              ),
                              _trainIcon(map['left'], !selectedLast),
                              Expanded(child: Container()),
                              _trainIcon(map['right'], selectedLast),
                              SizedBox(
                                width: Helper.width(75, size),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              });
        });
  }
}
