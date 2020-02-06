import 'package:flutter/widgets.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/trainclassfilter.dart';
import 'package:trains/ui/schedule/trainsclasscard.dart';

class TrainClassSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Status>(
        stream: InheritedBloc.searchBloc.status,
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data != Status.found)
            return Container();
          return Container(
            child: StreamBuilder<List<TrainClassFilter>>(
                stream: InheritedBloc.trainsBloc.classes,
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
                                    InheritedBloc.trainsBloc.updateClass(trainClass.trainClass),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 2),
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
