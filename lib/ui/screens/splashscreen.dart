import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: Center(
            child: Text(
              "Электрички",
              style: TextStyle(
                  color: Constants.WHITE,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.bold,
                  fontSize: 36),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(70),
          child: Container(
            width: 85,
            child: Image.asset(
              "assets/ivolga.png",
            ),
          ),
        )
      ],
    );
  }
}