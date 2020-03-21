import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/ui/mainscreen/mainscreen.dart';
import 'package:trains/ui/res/mycolors.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GlobalValues(
    child: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
    if (state == AppLifecycleState.resumed) {
      final globalValues = GlobalValues.of(context);
      globalValues.searchBloc.renewTimer();
    }
  }

  _body(context) {
    final globalValues = GlobalValues.of(context);
    // return Scaffold(
    //   body: Center(
    //     child: Text('text'),
    //   ),
    // );
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: FutureBuilder(
          future: globalValues.init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Container();
            return Scaffold(body: MainScreen());
          }),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Электрички',
      theme: _materialTheme(),
      home: _body(context),
    );
  }
}

ThemeData _materialTheme() {
  return ThemeData(
      scaffoldBackgroundColor: MyColors.PRIMARY_BACKGROUND,
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 18,
            fontFeatures: [FontFeature.enable('ss03')],
            fontFamily: "Moscow Sans",
            color: MyColors.PRIMARY_TEXT),
        headline2: TextStyle(
            fontSize: 24,
            fontFamily: "PT Root UI",
            fontWeight: FontWeight.w500,
            color: MyColors.PRIMARY_TEXT),
      ));
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
