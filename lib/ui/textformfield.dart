import 'package:flutter/material.dart';
import 'package:trains/data/Inheritedbloc.dart';
import 'package:trains/data/bloc.dart';
import 'package:trains/data/station.dart';

class InputForm extends StatefulWidget {
  InputForm(this.type, this.ctrl, this.focusOn);

  final TextEditingController ctrl;
  final FocusNode focusOn;
  final InputType type;

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool hasFocus = false;
  bool isFinished = false;

  Widget hint() {
    if (widget.type == InputType.from)
      return Text("Откуда");
    else if (widget.type == InputType.to) return Text("Куда");
    return Container();
  }

  Widget station() {
    if (hasFocus)
      return TextField(
        controller: widget.ctrl,
        focusNode: widget.focusOn,
      );
    if (isFinished) return Text(widget.ctrl.value.text);
    return Container();
  }

  Widget textButton() {
    return GestureDetector(
      onTap: () {
        setState(() {
          hasFocus = !hasFocus;
        });
      },
      child: Column(
        crossAxisAlignment: widget.type == InputType.from
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: <Widget>[
          hint(),
          station(),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.of(context);
    return StreamBuilder<Station>(
      stream: widget.type == InputType.from
          ? trainsBloc.fromStation.skipWhile((station) =>
              station.name.toLowerCase() ==
              widget.ctrl.value.text.toLowerCase())
          : trainsBloc.toStation.skipWhile((station) =>
              station.name.toLowerCase() ==
              widget.ctrl.value.text.toLowerCase()),
      builder: (context, snapshot) {
        if (snapshot.data != null) {
          widget.ctrl.text = snapshot.data.name;
          widget.focusOn.unfocus();
          isFinished = true;
        }
        return textButton();
//          TextFormField(
//          style: TextStyle(
//              fontSize: 18.0,
//              fontWeight: FontWeight.w700,
//              color: Colors.black,
//              fontFamily: 'Montserrat'),
//          onFieldSubmitted: (text) => trainsBloc.from.add(text),
//          autofocus: type == InputType.from ? true : false,
//          focusNode: focusOn,
//          controller: ctrl,
//          decoration: InputDecoration(
//              border: OutlineInputBorder(
//                  borderRadius: BorderRadius.circular(12.0),
//                  borderSide: BorderSide(width: 0.0, style: BorderStyle.none)),
//              filled: true,
//              fillColor: Colors.grey[100],
//              labelText: type == InputType.from ? "Откуда" : "Куда",
//              suffixIcon: IconButton(
//                  icon: Icon(Icons.clear),
//                  onPressed: () {
//                    FocusScope.of(context).requestFocus(focusOn);
//                    switch (type) {
//                      case InputType.from:
//                        {
//                          trainsBloc.from.add("");
//                          trainsBloc.setFromStation.add(null);
//                          break;
//                        }
//                      case InputType.to:
//                        {
//                          trainsBloc.to.add("");
//                          trainsBloc.setToStation.add(null);
//                          break;
//                        }
//                    }
//                    ctrl.clear();
//                  })),
//        );
      },
    );
  }
}
