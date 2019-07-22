import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.BACKGROUND_DARK_GREY,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Icon(
                Icons.train,
                color: Constants.accentColor,
                size: Constants.TEXT_SIZE_MAX * 2,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(
                "Электрички",
                style: TextStyle(
                  fontSize: Constants.TEXT_SIZE_MAX,
                  fontWeight: FontWeight.bold,
                  color: Constants.whiteHigh,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
