import 'package:flutter/material.dart';
import 'package:trains/ui/res/mycolors.dart';

class SearchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircularProgressIndicator(
              backgroundColor: MyColors.SECONDARY,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Поиск",
              style: TextStyle(
                fontSize: 30,
                fontFamily: "Moscow Sans",
                fontWeight: FontWeight.bold,
                color: MyColors.SECONDARY,
              ),
            ),
          )
        ],
      ),
    );
  }
}
