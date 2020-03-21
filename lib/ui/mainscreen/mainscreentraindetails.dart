import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/mainscreen/mainscreentrainclass.dart';
import 'package:trains/ui/res/stopstext.dart';
import 'package:trains/ui/res/timetext.dart';

class MainScreenTrainDetails extends StatelessWidget {
  final _detailsKey = GlobalKey();

  MainScreenTrainDetails({Key key}) : super(key: key);

  _updateScheme(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(Duration(milliseconds: 200), () {
        if (_detailsKey.currentContext != null) {
          final globalValues = GlobalValues.of(context);
          final size = MediaQuery.of(context).size;
          final renderBox =
              _detailsKey.currentContext.findRenderObject() as RenderBox;
          final topOffset = renderBox.localToGlobal(Offset.zero).dy;
          final bottomOffset = size.height - topOffset - renderBox.size.height;
          globalValues.schemeBloc.updateStops(topOffset, bottomOffset);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    final size = MediaQuery.of(context).size;
    return StreamBuilder<Train>(
        stream: globalValues.trainsBloc.selected,
        builder: (context, selectedStream) {
          if (!selectedStream.hasData) return Container();
          final train = selectedStream.data;
          final travelStops = train.price ?? 0;
          final travelStopsText = Helper.stopsToText(travelStops);
          final travelTime =
              Helper.timeDiffInMins(train.departure, train.arrival);
          final travelTimeText = Helper.minutesToText(travelTime);
          _updateScheme(context);
          return Column(
            key: _detailsKey,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              MainScreenTrainClass(),
              SizedBox(
                height: Helper.height(15, size),
              ),
              StopsText(
                text: travelStopsText,
              ),
              SizedBox(
                height: Helper.height(15, size),
              ),
              TimeText(
                text: travelTimeText,
              ),
            ],
          );
        });
  }
}
