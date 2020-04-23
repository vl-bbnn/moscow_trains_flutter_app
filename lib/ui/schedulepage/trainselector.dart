import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/mysizes.dart';
import 'package:trains/ui/schedulepage/traincard.dart';

class TrainSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    final size = MediaQuery.of(context).size;
    // print("Size: " + size.toString());
    final selectedTrainCardWidth =
        Helper.width(SelectedTrainSizes.CARD_WIDTH, size);
    // print("Selected Train Card Width: " + selectedTrainCardWidth.toString());
    final controller = PageController(
        viewportFraction: selectedTrainCardWidth / size.width, initialPage: 0);
    var oldPage = 0.0;
    controller.addListener(() {
      final page = controller.page;
      if (page != oldPage) {
        globalValues.trainsBloc.updatePage(page);
        oldPage = page;
      }
    });
    return StreamBuilder<List<Train>>(
        stream: globalValues.trainsBloc.results,
        builder: (context, resultsStream) {
          if (!resultsStream.hasData) return Container();
          final trains = resultsStream.data;
          final hasData = trains.isNotEmpty;
          return hasData
              ? PageView.builder(
                  controller: controller,
                  itemCount: hasData ? trains.length : 5,
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
    return new AnimatedBuilder(
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
            selectedDepartureTime: selectedDepartureTime);
      },
    );
  }
}
