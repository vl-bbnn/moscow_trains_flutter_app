import 'package:flutter/material.dart';
import 'package:trains/data/classes/train.dart';
import 'package:trains/ui/frontpanel/category/background/title/minutesleft.dart';
import 'package:trains/ui/frontpanel/category/background/title/traveltime.dart';

class CategorySubTitle extends StatelessWidget {
  CategorySubTitle({@required this.sublist});

  final List<Train> sublist;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MinutesLeft(
          sublist: sublist,
        ),
        TravelTime(sublist: sublist),
      ],
    );
  }
}
