import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:trains/ui/background.dart';
import 'package:trains/ui/frontpanel.dart';
import 'package:trains/ui/res/mycolors.dart';
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
      InheritedBloc.searchBloc.renewTimer();
    }
  }

  final frontPanelBloc = InheritedBloc.frontPanelBloc;

  _body() {
    return ScrollConfiguration(
      behavior: MyBehavior(),
      child: FutureBuilder(
          future: InheritedBloc.init(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done)
              return Container();
            frontPanelBloc
                .updateMaxHeight(MediaQuery.of(context).size.height - 200);
            return StreamBuilder<double>(
                stream: frontPanelBloc.panelMinHeight.distinct(),
                builder: (context, minHeightStream) {
                  final minHeight = minHeightStream.data ?? 100.0;
                  return StreamBuilder<double>(
                      stream: frontPanelBloc.panelMaxHeight.distinct(),
                      builder: (context, maxHeightStream) {
                        final maxHeight = maxHeightStream.data ?? 500.0;
                        return Scaffold(
                          resizeToAvoidBottomInset: false,
                          body: SlidingUpPanel(
                            controller: frontPanelBloc.panelController,
                            renderPanelSheet: false,
                            defaultPanelState: PanelState.CLOSED,
                            onPanelSlide: (slide) =>
                                frontPanelBloc.panelSlide.add(slide),
                            maxHeight: maxHeight,
                            minHeight: minHeight,
                            panelBuilder: (controller) {
                              frontPanelBloc.scheduleScrollController
                                  .add(controller);
                              return FrontPanel();
                            },
                            body: Background(),
                          ),
                        );
                      });
                });
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
      home: _body(),
    );
  }
}

ThemeData _materialTheme() {
  return ThemeData(
      scaffoldBackgroundColor: MyColors.BACKGROUND,
      textTheme: TextTheme(
        headline1: TextStyle(
            fontSize: 14,
            fontFamily: "PT Root UI",
            fontWeight: FontWeight.w500,
            color: MyColors.BLACK),
        headline2: TextStyle(
            fontSize: 14,
            fontFeatures: [FontFeature.enable('ss03')],
            fontFamily: "Moscow Sans",
            color: MyColors.GREY),
        headline3: TextStyle(
            fontSize: 14, fontFamily: "Moscow Sans", color: MyColors.GREY),
        subtitle1: TextStyle(
            fontSize: 12, fontFamily: "MoscowSans", color: MyColors.GREY),
      ));
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
