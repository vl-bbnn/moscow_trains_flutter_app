import 'package:flutter/material.dart';
import 'package:trains/data/classes/pause.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class PauseWarning extends StatelessWidget {
  PauseWarning({@required this.pause});
  final Pause pause;

  @override
  Widget build(BuildContext context) {
    if (pause.pauseTime < 60) return Container();
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Material(
        color: Constants.BACKGROUND_GREY_4DP,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
            side: BorderSide(color: Constants.red, width: 2.0)),
        child: Container(
          width: Constants.CATEGORY_TRAIN_SIZE,
          height: Constants.CATEGORY_TRAIN_SIZE,
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.watch_later,
                  color: Constants.red,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    "перерыв",
                    style: TextStyle(
                        color: Constants.red,
                        fontWeight: FontWeight.bold,
                        fontSize: Constants.TEXT_SIZE_SMALL),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                  child: Text(
                    Helper.shortMinutesText(pause.pauseTime),
                    style: TextStyle(
                        color: Constants.red,
                        fontWeight: FontWeight.bold,
                        fontSize: Constants.TEXT_SIZE_SMALL),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
