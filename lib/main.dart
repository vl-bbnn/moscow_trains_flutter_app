import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/frontpanel.dart';
import 'package:trains/ui/schedule/schedulepage.dart';
import 'data/blocs/inheritedbloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

void main() {
  runApp(InheritedBloc(
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
      final dateTimeBloc = InheritedBloc.dateTimeBloc;
      if (dateTimeBloc.shouldUpdateTime.value) dateTimeBloc.resetTime();
      dateTimeBloc.setDatesUpdater();
    }
  }

  final frontPanelBloc = InheritedBloc.frontPanelBloc;

  _body() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: WillPopScope(
        onWillPop: () async {
          await frontPanelBloc.panelClose.value();
          return true;
        },
        child: FutureBuilder(
            future: InheritedBloc.init(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Container();
              return StreamBuilder<double>(
                  stream: frontPanelBloc.panelMinHeight,
                  builder: (context, minHeightStream) {
                    // print("Min");
                    return StreamBuilder<double>(
                        stream: frontPanelBloc.panelMaxHeight,
                        builder: (context, maxHeightStream) {
                          final maxHeight = maxHeightStream.data ?? 400.0;
                          final minHeight = minHeightStream.data ?? 150.0;
                          // print("Max");
                          return Scaffold(
                            resizeToAvoidBottomInset: false,
                            body: SlidingUpPanel(
                              backdropColor: Constants.BACKGROUND,
                              backdropOpacity: 0.2,
                              controller: frontPanelBloc.panelController,
                              renderPanelSheet: false,
                              backdropEnabled: true,
                              onPanelSlide: (slide) =>
                                  frontPanelBloc.panelSlide.add(slide),
                              maxHeight: maxHeight,
                              minHeight: minHeight,
                              panel: FrontPanel(),
                              body: SchedulePage(),
                            ),
                          );
                        });
                  });
            }),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // if (Theme.of(context).platform == TargetPlatform.iOS)
    //   return CupertinoApp(
    //     title: "Электрички",
    //     theme: _cupertinoTheme(),
    //     home: _body(),
    //   );
    // else
      return MaterialApp(
        title: 'Электрички',
        theme: _materialTheme(),
        home: _body(),
      );
  }
}

CupertinoThemeData _cupertinoTheme() {
  return CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyle(color: Constants.WHITE)));
}

ThemeData _materialTheme() {
  return ThemeData(
      scaffoldBackgroundColor: Constants.BACKGROUND,
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 14,
            fontFamily: "PT Root UI",
            fontWeight: FontWeight.w500,
            color: Constants.WHITE),
        headline2: TextStyle(
            fontSize: 14,
            fontFeatures: [FontFeature.enable('ss03')],
            fontFamily: "Moscow Sans",
            color: Constants.GREY),
        headline3: TextStyle(
            fontSize: 14, fontFamily: "Moscow Sans", color: Constants.GREY),
        subtitle1: TextStyle(
            fontSize: 12, fontFamily: "MoscowSans", color: Constants.GREY),
      ),
      accentColor: Constants.ELEVATED_2);
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
