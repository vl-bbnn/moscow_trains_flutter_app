import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';

class ErrorScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.close,
              color: Constants.WARNING,
              size: 30,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ошибка",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Constants.GREY,
              ),
            ),
          )
        ],
      ),
    );
  }
}