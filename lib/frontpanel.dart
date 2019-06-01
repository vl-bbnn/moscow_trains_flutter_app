import 'package:flutter/material.dart';
import 'package:trains/data/bloc.dart';
import 'package:trains/ui/calendar.dart';

class FrontPanel extends StatelessWidget {
  FrontPanel(this.trainsBloc);
  final TrainsBloc trainsBloc;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Calendar();
  }
}
