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
              size: Constants.TEXT_SIZE_BIG,
              color: Constants.whiteMedium,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Ничего не найдено",
              style: TextStyle(
                fontSize: Constants.TEXT_SIZE_BIG,
                fontWeight: FontWeight.bold,
                color: Constants.whiteMedium,
              ),
            ),
          )
        ],
      ),
    );
  }
}
