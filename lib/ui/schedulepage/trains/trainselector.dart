import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/schedulepage/trains/traincard.dart';

class TrainSelector extends StatelessWidget {
  final Sizes sizes;

  const TrainSelector({Key key, this.sizes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalBloc = GlobalBloc.of(context);
    final size = MediaQuery.of(context).size;
    // print("Size: " + size.toString());
    final selectedTrainCardWidth = sizes.selectedTrainCardWidth;
    final controller = PageController(
        viewportFraction: selectedTrainCardWidth / size.width, initialPage: 0);
    globalBloc.trainsBloc.controller.add(controller);
    return StreamBuilder<List<Train>>(
        stream: globalBloc.trainsBloc.results,
        builder: (context, resultsStream) {
          if (!resultsStream.hasData) return Container();
          final trains = resultsStream.data;
          final hasData = trains.isNotEmpty;
          return hasData
              ? PageView.builder(
                  controller: controller,
                  itemCount: hasData ? trains.length : 0,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () => controller.animateToPage(index,
                        duration: Duration(milliseconds: 600),
                        curve: Curves.easeOut),
                    child: trainBuilder(
                        index: index,
                        train: hasData ? trains.elementAt(index) : null,
                        controller: controller,
                        prevDeparture: hasData && index > 0
                            ? trains.elementAt(index - 1).departure
                            : null,
                        nextDeparture: hasData && index < trains.length - 1
                            ? trains.elementAt(index + 1).departure
                            : null),
                  ),
                )
              : Container();
        });
  }

  trainBuilder({index, train, controller, prevDeparture, nextDeparture}) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        var value = index == 0 ? 1.0 : 0.0;
        var left = false;
        var right = true;
        if (controller.position.haveDimensions) {
          value = controller.page - index;
          left = value > 0;
          right = value < 0;
          value = (1 - value.abs()).clamp(0.0, 1.0);
        }
        final curvedValue = Curves.easeOut.transform(value);
        final selectedDepartureTime =
            left ? nextDeparture : right ? prevDeparture : null;
        return TrainCard(
          train: train,
          curvedValue: curvedValue,
          left: left,
          right: right,
          selectedDepartureTime: selectedDepartureTime,
          sizes: sizes,
        );
      },
    );
  }
}
