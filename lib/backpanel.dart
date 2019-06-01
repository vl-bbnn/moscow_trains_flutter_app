import 'package:flutter/material.dart';
import 'package:trains/data/train.dart';
import 'package:trains/ui/trainslist.dart';
import 'package:trains/data/bloc.dart';
import 'dart:async';

class BackPanel extends StatefulWidget {
  BackPanel({Key key, @required this.frontPanelOpen, @required this.trainsBloc})
      : super(key: key);
  final ValueNotifier<bool> frontPanelOpen;
  final TrainsBloc trainsBloc;

  @override
  _BackPanelState createState() => _BackPanelState();
}

class _BackPanelState extends State<BackPanel> {
  bool panelOpen;

  @override
  void initState() {
    panelOpen = widget.frontPanelOpen.value;
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
    super.initState();
    _timer();
  }

  void _timer() {
    print("Start. ${DateTime.now().minute}");
    var seconds = 60 - DateTime.now().second;
    print("$seconds");
    Future.delayed(
        Duration(seconds: seconds),
        () => Timer.periodic(Duration(minutes: 1), (Timer t) {
              print("Reload. ${DateTime.now().minute}");
              setState(() {});
            }));
  }

  void _subscribeToValueNotifier() =>
      setState(() => panelOpen = widget.frontPanelOpen.value);

  @override
  void didUpdateWidget(BackPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    oldWidget.frontPanelOpen.removeListener(_subscribeToValueNotifier);
    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Train>>(
        stream: widget.trainsBloc.shown,
        builder: (context, snapshot) {
          if (snapshot.data != null) {
            return Column(children: [
//              Container(
//                color: _color,
//                child: _detailsOpen
//                    ? Column(
//                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                        children: <Widget>[
//                          Container(
//                              height: 56.0, child: DetailsCard(_selectedTrain)),
//                          ThreadIndicator(thread: _selectedTrain.thread),
//                        ],
//                      )
//                    : Container(),
//              ),
              Expanded(
                  child: ListView.builder(
                      itemCount: snapshot.data.length,
                      itemBuilder: (context, index) {
                        int _tillNextTrain;
                        var train = snapshot.data.elementAt(index);
                        if (index < snapshot.data.length - 1)
                          _tillNextTrain = train.departure
                              .difference(
                                  snapshot.data.elementAt(index + 1).departure)
                              .abs()
                              .inMinutes;
                        else
                          _tillNextTrain = -1;
                        return Column(
                          children: <Widget>[
                            TrainCard(train),
                            _dividerWarning(_tillNextTrain, train.isLast),
                          ],
                        );
                      })),
              Container(
                alignment: Alignment.bottomCenter,
                color: Colors.white,
                height: 156.0,
                width: 10.0,
              )
            ]);
          } else {
            return Container();
          }
        });
  }

  String _timeString(minutes) {
    if (minutes < 60) return "$minutes мин";
    var _hours = (minutes / 60).floor();
    var _minutes = minutes % 60;
    return "$_hours ч $_minutes мин";
  }

  Widget _dividerWarning(int tillNextTrain, bool isLast) {
    var string = '';
    if (isLast)
      string = 'Последняя электричка';
    else if (tillNextTrain > 30)
      string = 'Перерыв ${_timeString(tillNextTrain)}';
    var isDivider = tillNextTrain < 30 && tillNextTrain > 0;
    return Column(
      children: <Widget>[
        !isDivider
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Expanded(child: _divider()),
                  Material(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(15.0),
                    elevation: 0.0,
                    child: Container(
                      padding: EdgeInsets.all(12.0),
                      child: isLast
                          ? RichText(
                              text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: 'Внимание! ',
                                        style: TextStyle(
                                            color: Colors.red[400],
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.w600)),
                                    TextSpan(text: string)
                                  ],
                                  style: TextStyle(
                                      color: Colors.black87,
                                      fontFamily: 'Montserrat')),
                            )
                          : Text(
                              string,
                              style: TextStyle(
                                  fontFamily: 'Montserrat',
                                  color: Colors.black87),
                            ),
                    ),
                  ),
                  Expanded(child: _divider()),
                ],
              )
            : _divider(),
        tillNextTrain < 0
            ? Center(
                child: Container(
                height: 10.0,
              ))
            : Container(),
      ],
    );
  }

  Widget _divider() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.0),
        child: Divider(
          color: Colors.grey,
        ),
      ),
    );
  }
}
