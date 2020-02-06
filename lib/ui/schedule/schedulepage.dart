import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/schedule/traincard.dart';
import 'package:trains/ui/screens/errorscreen.dart';
import 'package:trains/ui/screens/notfoundscreen.dart';
import 'package:trains/ui/screens/searchingscreen.dart';

class SchedulePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Status>(
        stream: InheritedBloc.searchBloc.status,
        builder: (context, status) {
          switch (status.data) {
            case Status.notFound:
              print("Not Found Screen");
              return NotFoundScreen();
            case Status.searching:
              print("Search Screen");
              return SearchingScreen();
            case Status.found:
              print("Schedule Screen");
              return StreamBuilder<List<Train>>(
                  stream: InheritedBloc.trainsBloc.results,
                  builder: (context, list) {
                    if (!list.hasData) return NotFoundScreen();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Center(
                        child: ListView(
                          children: list.data
                              .map((train) => TrainCard(
                                    train: train,
                                    first: train.uid == list.data.first.uid,
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  });
            default:
              return ErrorScreen();
          }
        });
  }
}
