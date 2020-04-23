import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trains/bottompanel.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/pagemanager.dart';
import 'package:trains/ui/common/mycolors.dart';

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
            return Scaffold(
                resizeToAvoidBottomInset: false, body: PageManager());
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
      debugShowCheckedModeBanner: false,
      title: 'Электрички',
      theme: _materialTheme(),
      home: _body(context),
    );
  }
}

ThemeData _materialTheme() {
  return ThemeData(
      scaffoldBackgroundColor: MyColors.BACK_PR,
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 18,
            fontFeatures: [FontFeature.enable('ss03')],
            fontFamily: "Moscow Sans",
            color: MyColors.TEXT_PR),
        headline2: TextStyle(
            fontSize: 18,
            fontFamily: "PT Root UI",
            fontWeight: FontWeight.w500,
            color: MyColors.TEXT_PR),
      ));
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
