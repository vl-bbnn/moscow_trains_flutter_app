import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';

class CategoriesDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35.0, vertical: 4.0),
      child: Container(
        height: 2.0,
        decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(1.0)),
            color: Constants.whiteDisabled),
      ),
    );
  }
}
