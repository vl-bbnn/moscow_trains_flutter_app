import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/data/classes/train.dart';

class MainScreenTrainClass extends StatelessWidget {
  final _classKey = GlobalKey();

  _classText(Train train) {
    switch (train.trainClass) {
      case TrainClass.regular:
        return "Стандарт";
      case TrainClass.comfort:
        return "Комфорт";
      case TrainClass.express:
        return "Экспресс";
    }
  }

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    return StreamBuilder<Status>(
        stream: globalValues.searchBloc.status,
        builder: (context, statusStream) {
          if (!statusStream.hasData) return Container();
          return StreamBuilder<Train>(
              stream: globalValues.trainsBloc.selected,
              builder: (context, selectedStream) {
                if (!selectedStream.hasData) return Container();
                final classText = _classText(selectedStream.data);
                final price = selectedStream.data.price ?? 0;
                return Row(
                  key: _classKey,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      classText.toUpperCase(),
                      style: Theme.of(context).textTheme.headline1,
                    ),
                    price != 0
                        ? Text(
                            (price.toString() + " ₽").toUpperCase(),
                            style: Theme.of(context).textTheme.headline1,
                          )
                        : Container()
                  ],
                );
              });
        });
  }
}
