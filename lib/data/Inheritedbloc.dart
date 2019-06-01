import 'package:flutter/material.dart';
import 'package:trains/data/bloc.dart';

class InheritedBloc extends InheritedWidget {
  final TrainsBloc trainsBloc;

  final FocusNode focusOnFrom = FocusNode();
  final FocusNode focusOnTo = FocusNode();
  final TextEditingController fromCtrl = TextEditingController();
  final TextEditingController toCtrl = TextEditingController();

  InheritedBloc({this.trainsBloc, Widget child}) : super(child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  static TrainsBloc of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(InheritedBloc)
            as InheritedBloc)
        .trainsBloc;
  }
}
