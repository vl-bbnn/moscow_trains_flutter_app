import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/search/stationspage/inputfield/inputfield.dart';
import 'package:trains/ui/backpanel/search/stationspage/inputswitcher/inputswitcher.dart';
import 'package:trains/ui/backpanel/search/stationspage/suggestions/persistentsuggestions.dart';
import 'package:trains/ui/backpanel/search/stationspage/suggestions/typingsuggestions.dart';

class StationsPage extends StatefulWidget {
  @override
  _StationsPageState createState() => _StationsPageState();
}

class _StationsPageState extends State<StationsPage>
    with WidgetsBindingObserver {
  var keyboardVisible = false;

  @override
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
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
          child: Material(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)),
            color: Constants.BACKGROUND_GREY_1DP,
            elevation: 1.0,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  InputSwitcher(),
                  InputField(),
                  TypingSuggestions(),
                ],
              ),
            ),
          ),
        ),
        !keyboardVisible ? PersistentSuggestions() : Container(),
      ],
    );
  }

  @override
  void didChangeMetrics() {
    setState(() {
      keyboardVisible = window.viewInsets.bottom > 0;
    });
  }
}
