import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/background/background.dart';
import 'package:trains/ui/navigation/bottomnavpanel.dart';
import 'package:trains/ui/navigation/topnavbar.dart';
import 'data/blocs/inheritedbloc.dart';

void main() {
  runApp(InheritedBloc(
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stationsBloc = InheritedBloc.stationsOf(context);
    final navBloc = InheritedBloc.navOf(context);

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Электрички',
      theme: _theme(),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: ScrollConfiguration(
          behavior: MyBehavior(),
          child: WillPopScope(
            onWillPop: () async {
              await navBloc.pop.value();
              return true;
            },
            child: FutureBuilder(
                future: InheritedBloc.init(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return Container();
                  else if (snapshot.connectionState == ConnectionState.done)
                    return Stack(
                      children: <Widget>[
                        Background(),
                        Align(
                          alignment: Alignment.topCenter,
                          child: TopNavBar(),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: BottomNavPanel(),
                        ),
                      ],
                    );
                  return Container();
                }),
          ),
        ),
      ),
    );
  }
}

ThemeData _theme() {
  ThemeData _baseTheme = ThemeData(
      scaffoldBackgroundColor: Constants.BLACK,
      iconTheme: IconThemeData(color: Constants.WHITE),
      textTheme: TextTheme(
          display1: TextStyle(
              fontSize: 56,
              fontFamily: "LexendDeca",
              fontWeight: FontWeight.w500,
              color: Constants.WHITE),
          display2: TextStyle(
              fontSize: 30,
              fontFamily: "LexendDeca",
              fontWeight: FontWeight.w500,
              color: Constants.WHITE),
          headline: TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w400,
              color: Constants.GREY),
          title: TextStyle(
              fontSize: 18, fontFamily: "MoscowSans", color: Constants.WHITE),
          button: TextStyle(
              fontSize: 18,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              color: Constants.GREY),
          subtitle: TextStyle(
              fontSize: 16, fontFamily: "MoscowSans", color: Constants.BLACK),
          subhead: TextStyle(
              color: Constants.GREY,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              fontSize: 12)),
      accentColor: Constants.accentColor);
  return _baseTheme;
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
