import 'package:flutter/material.dart';
import 'package:trains/bottompanel.dart';
import 'package:trains/data/blocs/appnavigationbloc.dart';
import 'package:trains/data/blocs/globalvalues.dart';

import 'background.dart';

class PageManager extends StatefulWidget {
  @override
  _PageManagerState createState() => _PageManagerState();
}

class _PageManagerState extends State<PageManager>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  Tween<double> tween;
  AnimationController animationController;
  Function() pageValueUpdater;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    tween = Tween(begin: 0.0, end: 1.0);
    animation =
        CurvedAnimation(curve: Curves.easeInOut, parent: animationController);
  }

  @override
  void dispose() {
    animation.removeListener(pageValueUpdater);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    pageValueUpdater = () {
      globalValues.appNavigationBloc.pageValue.add(animation.value);
    };
    animation.addListener(pageValueUpdater);
    return StreamBuilder<AppState>(
        stream: globalValues.appNavigationBloc.nextAppState,
        builder: (context, nextAppStateSnapshot) {
          if (!nextAppStateSnapshot.hasData)
            return Container(
              color: Colors.amberAccent,
            );
          final nextAppState = nextAppStateSnapshot.data;

          animationController.reverse(from: 1.0).then((_) {
            globalValues.appNavigationBloc.currentAppState.add(nextAppState);
            animationController.forward();
          });
          // print(appStates.toString());
          return Stack(
            alignment: Alignment.bottomCenter,
            children: <Widget>[Background(), BottomPanel()],
          );
          // final appStates = appStatesSnapshot.data;
          // return FutureBuilder<void>(
          //     future: animationController.reverse(from: 1.0),
          //     builder: (context, closingSnapshot) {
          //       globalValues.appNavigationBloc.pageState.add(PageState.closing);
          //       if (closingSnapshot.connectionState == ConnectionState.waiting)
          //         switch (appStates.elementAt(1)) {
          //           case AppState.Launch:
          //             return Container(
          //               color: Colors.blue,
          //             );
          //           case AppState.Schedule:
          //             return SchedulePage();
          //           case AppState.StationSelect:
          //             return SuggestionsList();
          //         }

          //       animationController.forward();
          //       globalValues.appNavigationBloc.pageState.add(PageState.opening);
          //       switch (appStates.elementAt(0)) {
          //         case AppState.Launch:
          //           return Container(
          //             color: Colors.green,
          //           );
          //         case AppState.Schedule:
          //           return SchedulePage();
          //         case AppState.StationSelect:
          //           return SuggestionsList();
          //       }

          //       return Container(
          //         color: Colors.red,
          //       );
          //     });
        });
  }
}
