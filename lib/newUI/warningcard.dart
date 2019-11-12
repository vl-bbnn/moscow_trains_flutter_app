import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/newData/blocs/inputtypebloc.dart';
import 'package:trains/newData/classes/warning.dart';

class WarningCard extends StatelessWidget {
  final Warning warning;

  const WarningCard({Key key, this.warning}) : super(key: key);

  List<Widget> _warningList() {
    final list = List<Widget>();
    if (warning.negative != 0) {
      list.add(Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Constants.PADDING_REGULAR,
              horizontal: Constants.PADDING_MEDIUM),
          child: Text(
            Helper.minutesToText(warning.negative)['fullText'],
            style: TextStyle(
                color: Constants.NEGATIVE_FOREGROUND,
                fontSize: 14,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600),
          ),
        ),
        color: Constants.NEGATIVE_BACKGROUND,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ));
    }
    if (warning.positive != 0) {
      list.add(Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: Constants.PADDING_REGULAR,
              horizontal: Constants.PADDING_MEDIUM),
          child: Text(
            Helper.minutesToText(warning.positive)['fullText'],
            style: TextStyle(
                color: Constants.POSITIVE_FOREGROUND,
                fontSize: 14,
                fontFamily: "Montserrat",
                fontWeight: FontWeight.w600),
          ),
        ),
        color: Constants.POSITIVE_BACKGROUND,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ));
    }
    if (list.isEmpty) list.add(Container());
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: _warningList(),
      ),
    );
  }
}
