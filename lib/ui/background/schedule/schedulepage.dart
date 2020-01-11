import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/background/schedule/traincard.dart';
import 'package:trains/ui/background/screens/errorscreen.dart';
import 'package:trains/ui/background/screens/notfoundscreen.dart';
import 'package:trains/ui/background/screens/searchingscreen.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return StreamBuilder<Status>(
        stream: trainsBloc.status,
        builder: (context, status) {
          switch (status.data) {
            case Status.notFound:
              return NotFoundScreen();
            case Status.searching:
              return SearchingScreen();
            case Status.found:
              return StreamBuilder<List<Train>>(
                  stream: trainsBloc.results,
                  builder: (context, list) {
                    if (!list.hasData) return NotFoundScreen();
                    return ListView(
                      children: list.data
                          .map((train) => TrainCard(
                                train: train,
                                first: train.uid==list.data.first.uid,
                              ))
                          .toList(),
                    );
                  });
            default:
              return ErrorScreen();
          }
        });
  }
}
