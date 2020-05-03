import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/common/mysizes.dart';

class SelectedRoad extends StatelessWidget {
  final Status status;
  final Sizes sizes;

  const SelectedRoad({
    this.status: Status.notFound,
    this.sizes,
  });

  backgroundColor() {
    switch (status) {
      case Status.searching:
      case Status.found:
        return MyColors.LE_B70;
      case Status.notFound:
        return MyColors.WA_B70;
    }
  }

  foregroundColor(TrainClass trainClass) {
    switch (trainClass) {
      case TrainClass.standart:
        return MyColors.ST_B70;
      case TrainClass.comfort:
        return MyColors.D3_B70;
      case TrainClass.express:
        return MyColors.EX_B70;
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheduleBloc = GlobalBloc.of(context).scheduleBloc;
    final selectedFullHeight = sizes.schemeSelectedHeight;
    final backColor = backgroundColor();
    return StreamBuilder<TrainClass>(
        stream: scheduleBloc.trainClass,
        builder: (context, trainClassSnapshot) {
          if (!trainClassSnapshot.hasData) return Container();
          final trainClass = trainClassSnapshot.data;
          final foreColor = foregroundColor(trainClass);
          return StreamBuilder<double>(
              stream: scheduleBloc.selectedValue,
              builder: (context, selectedValueSnapshot) {
                if (!selectedValueSnapshot.hasData) return Container();
                final height = selectedFullHeight * selectedValueSnapshot.data;
                return Container(
                  height: selectedFullHeight,
                  width: sizes.schemeLineWidth,
                  color: backColor,
                  child: status == Status.found
                      ? Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            height: height,
                            color: foreColor,
                          ),
                        )
                      : SizedBox(),
                );
              });
        });
  }
}
