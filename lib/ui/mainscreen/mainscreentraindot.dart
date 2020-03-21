import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/res/mycolors.dart';

class MainScreenTrainDot extends StatelessWidget {
  final Train train;

  const MainScreenTrainDot({Key key, this.train}) : super(key: key);

  _color() {
    switch (train.trainClass) {
      case TrainClass.regular:
        return MyColors.REGULAR;
      case TrainClass.comfort:
        return MyColors.COMFORT;
      case TrainClass.express:
        return MyColors.EXPRESS;
    }
  }

  _regularDot(size) {
    return Center(
      child: Container(
        width: 12,
        height: 12,
        decoration: ShapeDecoration(
            shape: CircleBorder(side: BorderSide(width: 2, color: _color()))),
      ),
    );
  }

  _selectedDot(size) {
    return Container(
      width: 18,
      height: 18,
      decoration: ShapeDecoration(
        shape: CircleBorder(),
        color: _color(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final globalValues = GlobalValues.of(context);
    return Row(
      children: <Widget>[
        SizedBox(
          width: Helper.width(18, size),
          height: Helper.height(18, size),
          child: Center(
            child: StreamBuilder<Train>(
                stream: globalValues.trainsBloc.selected,
                builder: (context, selectedStream) {
                  if (!selectedStream.hasData) return Container();
                  final selected = selectedStream.data.uid == train.uid;
                  if (!selected) return _regularDot(size);
                  return _selectedDot(size);
                }),
          ),
        ),
        SizedBox(
          width: Helper.width(18, size),
        )
      ],
    );
  }
}
