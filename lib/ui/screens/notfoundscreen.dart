import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';

class NotFoundScreen extends StatelessWidget {
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
              Icons.not_interested,
              size: 30,
              color: Constants.ELEVATED_2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ничего не найдено",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Constants.ELEVATED_2,
              ),
            ),
          )
        ],
      ),
    );
  }
}