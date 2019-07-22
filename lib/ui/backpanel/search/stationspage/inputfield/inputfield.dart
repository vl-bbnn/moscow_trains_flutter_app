import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/src/constants.dart';

class InputField extends StatefulWidget {
  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  StationsBloc stationsBloc;
  TextEditingController ctrl;

  @override
  void initState() {
    ctrl = new TextEditingController();
    ctrl.addListener(_updateCtrl);
    super.initState();
  }

  void _updateCtrl() {
    stationsBloc.textSink.add(ctrl.value.text);
  }

  @override
  Widget build(BuildContext context) {
    stationsBloc = InheritedBloc.stationsOf(context);
    stationsBloc.toSuggestionStream.listen((_) => ctrl.clear());
    stationsBloc.fromSuggestionStream.listen((_) => ctrl.clear());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Constants.accentColor,
        cursorWidth: 3.0,
        style: TextStyle(
            fontSize: Constants.TEXT_SIZE_MEDIUM,
            fontWeight: FontWeight.bold,
            color: Constants.whiteHigh),
        textInputAction: TextInputAction.send,
        controller: ctrl,
        decoration: InputDecoration(
          hintText: "Название станции",
          hintStyle: TextStyle(
              fontSize: Constants.TEXT_SIZE_MEDIUM,
              fontWeight: FontWeight.bold,
              color: Constants.whiteDisabled),
          isDense: true,
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(18.0),
              borderSide: BorderSide(color: Constants.accentColor, width: 2.0)),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: BorderSide(color: Constants.accentColor, width: 2.0)),
        ),
      ),
    );
  }
}
