import 'package:flutter/material.dart';

class SchedulePage extends StatefulWidget {
  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          body: Column(
            children: <Widget>[
              Expanded(
                  child: Center(
                child: Text("Schedule Page",style: Theme.of(context).textTheme.headline,),
              )),
              Container(
                height: 120,
                child: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              )
            ],
          ),
    );
  }
}