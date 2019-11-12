import 'package:flutter/material.dart';
import 'package:trains/newUI/searchpage.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 120,
        ),
        Expanded(
            child: Center(
          child: Text(
            "Main Page",
            style: Theme.of(context).textTheme.title,
          ),
        )),
        Container(
          height: 130,
        )
      ],
    );
  }
}
