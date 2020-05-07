import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/blocs/traincardbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/schedulepage/trains/traincard.dart';

class TrainSelector extends StatefulWidget {
  final Sizes sizes;

  const TrainSelector({Key key, this.sizes}) : super(key: key);

  @override
  _TrainSelectorState createState() => _TrainSelectorState();
}

class _TrainSelectorState extends State<TrainSelector>
    with SingleTickerProviderStateMixin {
  AnimationController controller;
  Animation animation;

  initState() {
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    animation = Tween(begin: 0.0, end: 1.0).animate(controller);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = GlobalBloc.of(context).trainsBloc;

    double startPosition = 0.0;
    double percent = 0;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      trainsBloc.dragPercent(0.0);
    });

    final dragUpdate = () {
      trainsBloc.dragPercent(animation.value.toDouble());
    };

    animation.addListener(dragUpdate);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragDown: (details) {
        startPosition = details.localPosition.dx;

        trainsBloc.dragStart();
      },
      onHorizontalDragUpdate: (details) {
        final delta = (details.globalPosition.dx - startPosition) / 2;

        percent = trainsBloc.dragUpdate(delta);
      },
      onHorizontalDragEnd: (_) {
        controller.reset();

        animation =
            Tween(begin: percent, end: percent.round()).animate(controller);

        controller.forward();
      },
      child: StreamBuilder<List<Train>>(
          stream: trainsBloc.results,
          builder: (context, trainsSnapshot) {
            if (!trainsSnapshot.hasData) return Container();

            final trains = trainsSnapshot.data;

            return ListView.builder(
                padding: EdgeInsets.only(
                    left: 15 + widget.sizes.selectedTrain.outerPadding,
                    right: widget.sizes.selectedTrain.cardWidth),
                scrollDirection: Axis.horizontal,
                controller: trainsBloc.controller,
                physics: NeverScrollableScrollPhysics(),
                itemCount: trains.length,
                itemBuilder: (context, index) {
                  return trainBuilder(
                      index,
                      trains.elementAt(index),
                      trainsBloc.controller,
                      index > 0
                          ? trains.elementAt(index - 1).departure
                          : trains.elementAt(index + 1).departure);
                });
          }),
    );
  }

  trainBuilder(int index, Train train, ScrollController controller,
      DateTime otherTrainDeparture) {
    var newValue = index == 0 ? 1.0 : 0.0;

    final valueNotifier = ValueNotifier<double>(newValue);

    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) {
        if (controller.position.haveDimensions) {
          newValue = (controller.offset /
                  (widget.sizes.regularTrain.cardWidth +
                      2 * widget.sizes.regularTrain.outerPadding)) -
              index;

          newValue = (1 - newValue.abs()).clamp(0.0, 1.0);
        }

        valueNotifier.value = newValue;

        return child;
      },
      child: Column(
        children: <Widget>[
          Expanded(
            child: SizedBox(),
          ),
          TrainCardBloc(
              otherTrainDeparture: otherTrainDeparture,
              train: train,
              valueInput: valueNotifier,
              sizes: widget.sizes,
              child: TrainCard(
                sizes: widget.sizes,
              )),
          Expanded(
            child: SizedBox(),
          ),
        ],
      ),
    );
  }
}
