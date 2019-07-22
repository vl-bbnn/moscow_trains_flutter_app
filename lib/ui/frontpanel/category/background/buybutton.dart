import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';

class BuyButton extends StatelessWidget {
  BuyButton({@required this.sublist});
  final List<Train> sublist;

  @override
  Widget build(BuildContext context) {
    var _price = 0;
    sublist.forEach((train) {
      if (train.departure.isAfter(DateTime.now())) {
        if (_price == 0) _price = train.price;
      }
    });
    if (_price != 0)
      return GestureDetector(
        onTap: () => {},
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Material(
            color: Constants.BACKGROUND_GREY_8DP,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0)),
            elevation: 4.0,
            child: Container(
              width: 80.0,
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
              child: Center(
                child: Text(
                  "$_price ₽",
                  style: TextStyle(
                      color: Constants.accentColor,
                      fontSize: Constants.TEXT_SIZE_MEDIUM + 2,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      );
    return Container();
  }
}
