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
              color: Constants.red,
              size: Constants.TEXT_SIZE_BIG,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ошибка",
              style: TextStyle(
                fontSize: Constants.TEXT_SIZE_BIG,
                fontWeight: FontWeight.bold,
                color: Constants.whiteDisabled,
              ),
            ),
          )
        ],
      ),
    );
  }
}