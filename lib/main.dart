import 'package:flutter/material.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/blocs/uibloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/ui/backpanel/backpanel.dart';
import 'package:trains/ui/panels.dart';
import 'package:trains/ui/screens/errorscreen.dart';
import 'package:trains/ui/screens/splashscreen.dart';

void main() {
  final trainsBloc = TrainsBloc();
  final stationsBloc = StationsBloc();
  final uiBloc = UIBloc();
//  final dateTimeBloc = DateTimeBloc();
  runApp(InheritedBloc(
    trainsBloc: trainsBloc,
    stationsBloc: stationsBloc,
    uiBloc: uiBloc,
//    dateTimeBloc: dateTimeBloc,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stationsBloc = InheritedBloc.stationsOf(context);
    return MaterialApp(
      title: 'Электрички',
      theme: _theme(),
      home: Scaffold(
        body: SafeArea(
            child: FutureBuilder(
                future: stationsBloc.init(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return SplashScreen();
                  else if (snapshot.connectionState == ConnectionState.done)
                    return Panels();
                  return ErrorScreen();
                })),
      ),
    );
  }
}

ThemeData _theme() {
  ThemeData _baseTheme = ThemeData(
      scaffoldBackgroundColor: Constants.BACKGROUND_DARK_GREY,
      fontFamily: "FiraSans",
      accentColor: Constants.accentColor);
  return _baseTheme;
}
