import 'package:flutter/material.dart';
import 'package:trains/backpanel.dart';
import 'package:trains/frontpanel.dart';
import 'package:trains/frontpanelheader.dart';
import 'package:trains/data/Inheritedbloc.dart';
import 'src/backdrop.dart';
import 'package:trains/data/bloc.dart';
import 'package:intl/intl.dart';

void main() {
  final trainsBloc = TrainsBloc();
  runApp(InheritedBloc(
    trainsBloc: trainsBloc,
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Электрички',
      theme: _theme(),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.0,
          title: Text(
            "Электрички",
            style: TextStyle(fontSize: 24.0, color: Colors.black),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.account_circle,
                size: 28.0,
                color: Colors.black,
              ),
              onPressed: () {},
            )
          ],
        ),
        body: SafeArea(child: Panels()),
      ),
    );
  }
}

ThemeData _theme() {
  ThemeData _baseTheme = ThemeData(
      scaffoldBackgroundColor: Colors.white,
      fontFamily: "Montserrat",
      primaryColor: Colors.red,
      primaryColorDark: Colors.red,
      accentColor: Colors.redAccent);
  return _baseTheme;
}

class Panels extends StatelessWidget {
  final frontPanelVisible = ValueNotifier<bool>(false);
  final double _addPerSuggestionsRow = 58.0;
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.of(context);
    return StreamBuilder<int>(
      stream: trainsBloc.suggestionsRows,
      builder: (context, snapshot) {
        double _addHeight = 0.0;
        if (snapshot.data != null)
          _addHeight = _addPerSuggestionsRow * snapshot.data.toDouble();
        return Backdrop(
          frontLayer: FrontPanel(trainsBloc),
          backLayer: BackPanel(
            frontPanelOpen: frontPanelVisible,
            trainsBloc: trainsBloc,
          ),
          frontHeader: FrontPanelTitle(trainsBloc),
          panelVisible: frontPanelVisible,
          frontHeaderHeight: 156.0 + _addHeight,
          frontPanelOpenHeight: 100.0,
          frontPanelPadding: EdgeInsets.all(0.0),
          frontHeaderVisibleClosed: true,
        );
      },
    );
  }
}
