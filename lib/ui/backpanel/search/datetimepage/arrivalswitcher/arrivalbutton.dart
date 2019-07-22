import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/src/constants.dart';

enum ArrivalButtonType { departure, arrival }

class ArrivalButton extends StatelessWidget {
  final ArrivalButtonType type;

  const ArrivalButton({Key key, this.type}) : super(key: key);

  _label() {
    switch (type) {
      case ArrivalButtonType.departure:
        return "Отправлением";
      case ArrivalButtonType.arrival:
        return "Прибытием";
    }
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    return StreamBuilder<Map<SearchParameter, Object>>(
        stream: trainsBloc.searchParametersStream,
        builder: (context, parameters) {
          if (parameters.data == null) return Container();
          var arrival = parameters.data[SearchParameter.arrival] as bool;
          var pressed = (arrival && type == ArrivalButtonType.arrival) ||
              (!arrival && type == ArrivalButtonType.departure);
          return GestureDetector(
            onTap: () {
              bool newArrival = type == ArrivalButtonType.arrival;
              trainsBloc.updateArrival(newArrival);
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                color: pressed
                    ? Constants.BACKGROUND_GREY_1DP
                    : Constants.BACKGROUND_GREY_4DP,
                elevation: pressed ? 0.0 : 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: pressed
                        ? BorderSide(color: Constants.accentColor, width: 2.0)
                        : BorderSide(style: BorderStyle.none)),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 150.0,
                  child: Text(
                    _label(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: pressed
                            ? Constants.TEXT_SIZE_MEDIUM
                            : Constants.TEXT_SIZE_MEDIUM + 1,
                        color: pressed
                            ? Constants.accentColor
                            : Constants.whiteMedium),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
