import 'package:flutter/widgets.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/trainclass.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/background/schedule/trainsclasscard.dart';

class TrainClassSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    final trainClassesBloc = InheritedBloc.trainClassesOf(context);
    return StreamBuilder<Status>(
        stream: trainsBloc.status,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data != Status.found)
            return Container();
          return Container(
            child: StreamBuilder<List<TrainClass>>(
                stream: trainClassesBloc.classes,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data.isEmpty)
                    return Container();
                  return Align(
                    alignment: Alignment.topLeft,
                    child: ListView(
                      children: snapshot.data
                          .map((trainClass) => GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                onTap: () =>
                                    trainClassesBloc.update(trainClass.type),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: Constants.PADDING_SMALL),
                                  child: RotatedBox(
                                    quarterTurns: 3,
                                    child: TrainClassCard(
                                      trainClass: trainClass,
                                    ),
                                  ),
                                ),
                              ))
                          .toList(),
                      scrollDirection: Axis.vertical,
                      reverse: true,
                    ),
                  );
                }),
          );
        });
  }
}
