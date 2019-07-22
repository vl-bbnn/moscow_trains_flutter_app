import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';

class HelloScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                "Здравствуйте! Начните с выбора станций",
                style: TextStyle(
                  fontSize: Constants.TEXT_SIZE_BIG,
                  fontWeight: FontWeight.bold,
                  color: Constants.whiteHigh,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                "Вы так же можете указать нужное время отправления или прибытия",
                style: TextStyle(
                  fontSize: Constants.TEXT_SIZE_MEDIUM,
                  fontWeight: FontWeight.bold,
                  color: Constants.whiteMedium,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              child: Text(
                "Я могу найти ближайшую станцию. Нажмите здесь, чтобы дать мне доступ к вашему местоположению",
                style: TextStyle(
                  fontSize: Constants.TEXT_SIZE_SMALL,
                  fontWeight: FontWeight.bold,
                  color: Constants.whiteDisabled,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
