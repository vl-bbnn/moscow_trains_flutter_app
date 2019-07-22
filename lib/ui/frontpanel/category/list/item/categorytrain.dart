import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/frontpanel/category/list/item/trainindicator.dart';

class CategoryTrain extends StatelessWidget {
  CategoryTrain({@required this.train});

  final Train train;

  Duration _howSoon(DateTime time) {
    return time.difference(DateTime.now().toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return StreamBuilder<Map<SearchParameter, Object>>(
        stream: trainsBloc.searchParametersStream,
        builder: (context, parameters) {
          final selected = parameters.hasData
              ? train.uid == (parameters.data[SearchParameter.thread] as String)
              : false;
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Material(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  side: BorderSide(
                      width: selected ? 2.0 : 0.0,
                      color: selected
                          ? Constants.accentColor
                          : Constants.BACKGROUND_GREY_8DP)),
              elevation: selected ? 0.0 : 4.0,
              color: selected
                  ? Constants.BACKGROUND_GREY_4DP
                  : Constants.BACKGROUND_GREY_8DP,
              child: Container(
                width: Constants.CATEGORY_TRAIN_SIZE,
                height: Constants.CATEGORY_TRAIN_SIZE,
                padding: const EdgeInsets.all(12.0),
                child: Opacity(
                  opacity: _howSoon(train.departure).isNegative ? 0.6 : 1.0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        DateFormat('kk:mm').format(train.departure),
                        style: TextStyle(
                            fontSize: Constants.TEXT_SIZE_BIG,
                            fontWeight: FontWeight.w700,
                            color: !_howSoon(train.departure).isNegative &&
                                    _howSoon(train.departure).abs().inMinutes <=
                                        15
                                ? Constants.red
                                : selected
                                    ? Constants.accentColor
                                    : Constants.whiteHigh),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TrainIndicator(
                          train: train,
                          selected: selected,
                        ),
                      ),
                      Text(
                        DateFormat('kk:mm').format(train.arrival),
                        style: TextStyle(
                            fontSize: Constants.TEXT_SIZE_BIG,
                            fontWeight: FontWeight.w700,
                            color: selected
                                ? Constants.accentColor
                                : Constants.whiteHigh),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}
