import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/src/constants.dart';

class InputButton extends StatelessWidget {
  final InputType type;

  const InputButton({Key key, this.type}) : super(key: key);

  _label() {
    switch (type) {
      case InputType.from:
        return "Откуда";
      case InputType.to:
        return "Куда";
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsBloc = InheritedBloc.stationsOf(context);
    return StreamBuilder<InputType>(
        stream: stationsBloc.inputStream,
        builder: (context, parameters) {
          if (parameters.data == null) return Container();
          var pressed = parameters.data == type;
          return GestureDetector(
            onTap: () {
              stationsBloc.inputSink.add(type);
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
                      ? BorderSide(width: 2.0, color: Constants.accentColor)
                      : BorderSide(style: BorderStyle.none),
                ),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 110.0,
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
