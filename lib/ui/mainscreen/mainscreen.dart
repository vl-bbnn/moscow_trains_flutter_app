import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/src/helper.dart';
import 'package:trains/ui/mainscreen/mainscreenbottompanel.dart';
import 'package:trains/ui/mainscreen/mainscreenscheme.dart';
import 'package:trains/ui/mainscreen/mainscreenstation.dart';
import 'package:trains/ui/mainscreen/mainscreentoppanel.dart';
import 'package:trains/ui/mainscreen/mainscreentraindetails.dart';
import 'package:trains/ui/res/mycolors.dart';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final padding = MediaQuery.of(context).padding;
    final globalValues = GlobalValues.of(context);
    var registerDrag = true;
    return StreamBuilder<Status>(
        stream: globalValues.searchBloc.status,
        builder: (context, statusStream) {
          if (!statusStream.hasData) return Container();
          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            // onPanDown: (details) => print(details),
            onHorizontalDragDown: (_) {
              registerDrag = true;
            },
            onHorizontalDragUpdate: (details) {
              if (registerDrag) {
                if (details.primaryDelta < 0)
                  globalValues.trainsBloc.next();
                else
                  globalValues.trainsBloc.prev();
                registerDrag = false;
              }
            },
            child: Column(
              children: <Widget>[
                MainScreenTopPanel(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: Helper.width(10, size)),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        color: MyColors.SECONDARY_BACKGROUND,
                        child: Row(
                          children: <Widget>[
                            MainScreenScheme(),
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: Helper.width(25, size),
                                        vertical: Helper.height(40, size)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        MainScreenStation(
                                          type: QueryType.departure,
                                        ),
                                        SizedBox(
                                          height: Helper.height(40, size),
                                        ),
                                        MainScreenTrainDetails(),
                                        SizedBox(
                                          height: Helper.height(40, size),
                                        ),
                                        MainScreenStation(
                                          type: QueryType.arrival,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                MainScreenBottomPanel(),
              ],
            ),
          );
        });
  }
}
