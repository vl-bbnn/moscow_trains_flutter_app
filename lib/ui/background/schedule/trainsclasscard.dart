import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/classes/trainclass.dart';
import 'package:trains/data/src/constants.dart';

class TrainClassCard extends StatelessWidget {
  final TrainClass trainClass;

  const TrainClassCard({Key key, this.trainClass}) : super(key: key);

  Color _color() {
    switch (trainClass.type) {
      case TrainType.regular:
        return Constants.REGULAR;
      case TrainType.comfort:
        return Constants.COMFORT;
      case TrainType.express:
        return Constants.EXPRESS;
      default:
        return Constants.PRIMARY;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final selected = trainClass.selected;
    return Container(
      color: Constants.BLACK,
      child: Padding(
        padding: const EdgeInsets.only(
            left: Constants.PADDING_MEDIUM,
            right: Constants.PADDING_MEDIUM,
            bottom: Constants.PADDING_MEDIUM),
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
                    padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                    child: Text(
                      trainClass.name,
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(color: !selected ? Constants.GREY : color),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(Constants.PADDING_SMALL),
                    child: Text(
                      trainClass.price.toString() + " ₽",
                      style: Theme.of(context)
                          .textTheme
                          .subtitle
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
