import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/newData/blocs/datebloc.dart';
import 'package:trains/newData/blocs/fetchbloc.dart';
import 'package:trains/newData/blocs/navbloc.dart';
import 'package:trains/newData/blocs/searchbloc.dart';
import 'package:trains/newData/blocs/suggestions/persistentsuggestionsbloc.dart';
import 'package:trains/newData/blocs/suggestions/typingsuggestionsbloc.dart';
import 'package:trains/newData/blocs/timebloc.dart';
import 'package:trains/newUI/topnavbar.dart';
import 'package:trains/newData/blocs/trainclassesbloc.dart';
import 'package:trains/newUI/background.dart';
import 'package:trains/newUI/bottomnavpanel.dart';
import 'package:trains/newUI/mainpage.dart';
import 'package:trains/newUI/resultspage.dart';
import 'package:trains/newUI/searchpage.dart';
import 'package:trains/newUI/stationselectpage.dart';
import 'package:trains/ui/screens/errorscreen.dart';
import 'package:trains/ui/screens/splashscreen.dart';

import 'newData/blocs/inheritedbloc.dart';
import 'newData/blocs/inputtypebloc.dart';
import 'newData/blocs/stationsbloc.dart';
import 'newData/blocs/trainsbloc.dart';

void main() {
  final stationsBloc = StationsBloc();
  final fetchBloc = FetchBloc();
  final stationTypeBloc = InputTypeBloc();
  final dateTimeTypeBloc = InputTypeBloc();
  final searchBloc = SearchBloc(
    stationType: stationTypeBloc.type,
    dateTimeType: dateTimeTypeBloc.type,
    callback: (fromStation, toStation, fromDateTime, dateTimeType) =>
        fetchBloc.search(fromStation, toStation, fromDateTime, dateTimeType),
  );
  final persistentSuggestionsBloc = PersistentSuggestionsBloc(
    allStationsStream: stationsBloc.stream,
    fromController: searchBloc.fromStation,
    toController: searchBloc.toStation,
  );
  final navBloc = NavBloc();
  final typingSuggestionsBloc = TypingSuggestionsBloc(
      persistentFromList: persistentSuggestionsBloc.fromList,
      persistentToList: persistentSuggestionsBloc.toList,
      allStationsStream: stationsBloc.stream,
      updateSearch: searchBloc.updateStation,
      pop: navBloc.pop,
      stationType: stationTypeBloc.type);
  final trainClassesBloc = TrainClassesBloc(trains: fetchBloc.trains);
  final trainsBloc = TrainsBloc(
      targetDateTimeType: dateTimeTypeBloc.type,
      targetDateTime: searchBloc.dateTime,
      allTrains: fetchBloc.trains,
      deselectedTypes: trainClassesBloc.excludedTypes);
  final timeBloc = TimeBloc(updateSearch: searchBloc.updateTime);
  final dateBloc = DateBloc(updateSearch: searchBloc.updateDate);
  runApp(InheritedBloc(
    fetchBloc: fetchBloc,
    stationsBloc: stationsBloc,
    searchBloc: searchBloc,
    dateTimeTypeBloc: dateTimeTypeBloc,
    timeBloc: timeBloc,
    dateBloc: dateBloc,
    child: MyApp(),
    stationTypeBloc: stationTypeBloc,
    persistentSuggestionsBloc: persistentSuggestionsBloc,
    typingSuggestionsBloc: typingSuggestionsBloc,
    navBloc: navBloc,
    trainClassesBloc: trainClassesBloc,
    trainsBloc: trainsBloc,
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
      initialRoute: '/',
      routes: {
        '/main': (context) => MainPage(),
        '/results': (context) => ResultsPage(),
        '/stationSelect': (context) => StationSelectPage(),
        '/search': (context) => SearchPage(),
      },
      home: ScrollConfiguration(
        behavior: MyBehavior(),
        child: WillPopScope(
          onWillPop: () {
            navBloc.pop.value();
          },
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            body: FutureBuilder(
                future: stationsBloc.init(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting)
                    return SplashScreen();
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
                  return ErrorScreen();
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
              fontSize: 20,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.bold,
              color: Constants.WHITE),
          button: TextStyle(
              fontSize: 18,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w500,
              color: Constants.GREY),
          subtitle: TextStyle(
              fontSize: 16,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              color: Constants.GREY),
          subhead: TextStyle(
              color: Constants.GREY,
              fontFamily: "Montserrat",
              fontWeight: FontWeight.w600,
              fontSize: 14)),
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
