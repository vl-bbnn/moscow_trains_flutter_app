import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/classes/trainclassfilter.dart';
import 'package:trains/data/src/constants.dart';

class TrainClassCard extends StatelessWidget {
  final TrainClassFilter trainClass;

  const TrainClassCard({Key key, this.trainClass}) : super(key: key);

  Color _color() {
    switch (trainClass.trainClass) {
      case TrainClass.regular:
        return Constants.REGULAR;
      case TrainClass.comfort:
        return Constants.COMFORT;
      case TrainClass.express:
        return Constants.EXPRESS;
      default:
        return Constants.ELEVATED_2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final selected = trainClass.selected;
    return Container(
      color: Constants.BLACK,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            15,0,15,15),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: color,
                        blurRadius: 20,
                        spreadRadius: selected ? 4 : 2)
                  ],
                  color: color,
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(18.5),
                      bottomLeft: Radius.circular(18.5)),
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(2),
                    child: Text(
                      trainClass.price.toString() + " ₽",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1
                          .copyWith(color: !selected ? Constants.GREY : color),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
