import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/newData/blocs/trainsbloc.dart';
import 'package:trains/newData/blocs/inheritedbloc.dart';
import 'package:trains/newData/classes/trainclass.dart';
import 'package:trains/newUI/selectedtime.dart';
import 'package:trains/newUI/trainclassselector.dart';
import 'package:trains/newUI/trainsclasscard.dart';
import 'package:trains/newUI/trainsselector.dart';
import 'package:trains/ui/screens/notfoundscreen.dart';
import 'package:trains/ui/screens/searchingscreen.dart';

class ResultsPage extends StatefulWidget {
  @override
  _ResultsPageState createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  var verticalStartPosition = 0.0;
  var verticalInitialOffset = 0.0;
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return StreamBuilder<Status>(
        stream: trainsBloc.status,
        builder: (context, snapshot) {
          switch (snapshot.data) {
            case Status.notFound:
              return NotFoundScreen();
            case Status.searching:
              return SearchingScreen();
            case Status.found:
              return GestureDetector(
                behavior: HitTestBehavior.translucent,
                onVerticalDragDown: (details) {
                  verticalStartPosition = details.localPosition.dy;
                  verticalInitialOffset = trainsBloc.scroll.offset;
                  // trainsBloc.showSelected.add(false);
                },
                onVerticalDragUpdate: (details) {
                  final newOffset = verticalInitialOffset +
                      (verticalStartPosition - details.localPosition.dy) * 2;
                  trainsBloc.jumpToOffset(newOffset);
                },
                onVerticalDragEnd: (details) {
                  trainsBloc.round();
                },
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Constants.BACKGROUND,
                        child: Center(
                          child: Container(
                              width: Constants.TRAINCARD_WIDTH,
                              child: Stack(
                                children: <Widget>[
                                  TrainSelector(),
                                  Positioned(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    child: Column(
                                      children: <Widget>[
                                        Container(
                                          height: MediaQuery.of(context)
                                              .padding
                                              .top,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: 80,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 125 + Constants.PADDING_PAGE,
                            bottom: Constants.PADDING_PAGE),
                        child: Column(
                          children: <Widget>[
                            StreamBuilder<int>(
                                stream: trainsBloc.selected,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData || snapshot.data > 0)
                                    return RotatedBox(
                                        quarterTurns: 3,
                                        child: GestureDetector(
                                            behavior:
                                                HitTestBehavior.translucent,
                                            onTap: () {
                                              trainsBloc.reset();
                                            },
                                            child: SelectedTime()));
                                  else
                                    return Container();
                                }),
                            Expanded(
                              child: TrainClassSelector(),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            default:
              return Center(
                child: Text("Что-то пошло не так"),
              );
          }
        });
  }
}
