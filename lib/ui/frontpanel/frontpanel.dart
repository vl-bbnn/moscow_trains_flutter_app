import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/frontpanel/category/category.dart';
import 'package:trains/ui/screens/notfoundscreen.dart';
import 'package:trains/ui/screens/searchingscreen.dart';

class FrontPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return StreamBuilder<Results>(
        stream: trainsBloc.searchingStream,
        builder: (context, searching) {
          if (!searching.hasData)
            return Container();
          else
            switch (searching.data) {
              case Results.notFound:
                return NotFoundScreen();
              case Results.searching:
                return SearchingScreen();
              case Results.found:
                return ListView(
                  physics: AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    Category(TrainType.suburban),
                    Category(TrainType.lastm),
                    Category(TrainType.last),
                  ],
                );
            }
        });
  }
}
