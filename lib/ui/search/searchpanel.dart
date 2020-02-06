import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/ui/search/dateselector.dart';
import 'package:trains/ui/search/timeselector.dart';

class SearchPanel extends StatelessWidget {
  _updatePanelHeight(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox = context.findRenderObject() as RenderBox;
      InheritedBloc.frontPanelBloc.searchPanelHeight.add(renderBox.size.height);
    });
  }

  @override
  Widget build(BuildContext context) {
    _updatePanelHeight(context);
    return Column(
      children: <Widget>[
        SizedBox(
          height: 30,
        ),
        // Container(
        //   height: 150,
        //   width: MediaQuery.of(context).size.width,
        //   child: CupertinoDatePicker(
        //     onDateTimeChanged: (DateTime value) {
        //       print(value);
        //     },
        //     mode: CupertinoDatePickerMode.dateAndTime,
        //     use24hFormat: true,
        //   ),
        // ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: TimeSelector(),
        ),
        SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20),
          child: DateSelector(),
        ),
        SizedBox(
          height: 40,
        )
      ],
    );
  }
}
