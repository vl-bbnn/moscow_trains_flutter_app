import 'package:flutter/material.dart';
import 'package:rxdart/subjects.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/src/constants.dart';

enum InputType { Station, Time }

class InputSelector extends StatelessWidget {
  final InputType inputType;

  const InputSelector({Key key, @required this.inputType}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 295,
      height: 48,
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
              side: BorderSide(color: Constants.ELEVATED_3, width: 2))),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          _button(Input.departure),
          SizedBox(
            width: 5,
          ),
          _button(Input.arrival),
        ],
      ),
    );
  }

  _button(Input type) {
    BehaviorSubject<Input> stream;
    String text;
    switch (inputType) {
      case InputType.Station:
        stream = InheritedBloc.stationTypeBloc.type;
        switch (type) {
          case Input.departure:
            text = "отправления";
            break;
          case Input.arrival:
            text = "прибытия";
            break;
        }
        break;
      case InputType.Time:
        stream = InheritedBloc.reqTypeBloc.type;
        switch (type) {
          case Input.departure:
            text = "после";
            break;
          case Input.arrival:
            text = "до";
            break;
        }
        break;
      default:
        stream.close();
    }
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => stream.add(type),
      child: StreamBuilder<Input>(
          stream: stream,
          builder: (context, snapshot) {
            final selected = stream.value == type;
            return Container(
              width: 140,
              decoration: selected
                  ? ShapeDecoration(
                      color: Constants.ELEVATED_3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)))
                  : null,
              padding: const EdgeInsets.all(10),
              child: Text(
                text.toUpperCase(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline2.copyWith(
                    color: selected ? Constants.WHITE : Constants.GREY),
              ),
            );
          }),
    );
  }
}
