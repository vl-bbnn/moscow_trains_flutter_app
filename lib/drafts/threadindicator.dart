//library dots_indicator;
//
//import 'dart:async';
//import 'dart:math';
//
//import 'package:flutter/material.dart';
//import 'package:intl/intl.dart';
//import 'package:trains/drafts/thread.dart';
//
//class ThreadIndicator extends StatefulWidget {
//  static const Size kDefaultSize = const Size.square(4.0);
//  static const Size kDefaultActiveSize = const Size.square(12.0);
//  static const EdgeInsets kDefaultSpacing = const EdgeInsets.all(0.0);
//  static const ShapeBorder kDefaultShape = const CircleBorder();
//  final Thread thread;
//  final Color dotColor;
//  final Size dotSize;
//  final Size dotActiveSize;
//  final ShapeBorder dotShape;
//  final ShapeBorder dotActiveShape;
//  final EdgeInsets dotSpacing;
//
//  ThreadIndicator(
//      {Key key,
//      @required this.thread,
//      this.dotColor = Colors.grey,
//      this.dotSize = kDefaultSize,
//      this.dotActiveSize = kDefaultActiveSize,
//      this.dotShape = kDefaultShape,
//      this.dotActiveShape = kDefaultShape,
//      this.dotSpacing = kDefaultSpacing});
//
//  @override
//  _ThreadIndicatorState createState() => _ThreadIndicatorState();
//}
//
//class _ThreadIndicatorState extends State<ThreadIndicator> {
//  int _firstIndex;
//  Color dotActiveColor = Colors.white;
//  int position;
//  int lookPosition;
//  int _lookStationIndex;
//  bool _isStation = true;
//  int _numberOfDots = 10;
//
//  List<Widget> _buildDots() {
//    List<Widget> dots = [];
//    for (int i = 0; i < _numberOfDots; i++) {
//      final color = (i == position) ? dotActiveColor : widget.dotColor;
//      final size = (i == position) ? widget.dotActiveSize : widget.dotSize;
//      final shape = (i == position) ? widget.dotActiveShape : widget.dotShape;
//      final elevation = (i == position) ? 4.0 : 0.0;
//      var _dot = Container(
//        child: Material(
//          elevation: elevation,
//          shape: shape,
//          color: color,
//        ),
//        width: size.width,
//        height: size.height,
//        margin: widget.dotSpacing,
//      );
//      Widget _top = Container();
//      Widget _bottom = Container();
//      if ((i - position).abs() <= 1 || i == lookPosition) {
////        print("Position - $position\nIndex - $i\nStation - $_isStation");
//        _top = _topPart(i);
//        _bottom = _bottomPart(i);
//      }
//      dots.add(Container(
//          child: Column(
//        mainAxisAlignment: MainAxisAlignment.center,
//        children: <Widget>[
//          _top,
//          _dot,
//          _bottom,
//        ],
//      )));
//    }
//    return dots;
//  }
//
//  Widget _topPart(int index) {
//    if (index == lookPosition) return _stopName(_lookStationIndex);
//    if (index == 0 || index == _numberOfDots) {
//      return _stopName(index);
//    } else {
//      if (!_isStation) {
//        if (index < position) return _stopName(_firstIndex - 1);
//        if (index > position) return _stopName(_firstIndex);
//      } else {
//        if (index == position) return _stopName(_firstIndex);
//      }
//    }
//    return Container();
//  }
//
//  Widget _stopName(int index) => Text(
//        "${widget.thread.stops.elementAt(index).station.name}",
//        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
//      );
//
//  Widget _stopTime(int index) {
//    DateTime _time;
//    if (index == 0)
//      _time = widget.thread.stops.first.departure;
//    else
//      _time = widget.thread.stops.elementAt(index).arrival;
//    return Text(
//      "${DateFormat('kk:mm').format(_time)}",
//      style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16.0),
//    );
//  }
//
//  Widget _bottomPart(int index) {
//    if (index == lookPosition) return _stopTime(_lookStationIndex);
//    if (index == 0 || index == _numberOfDots) {
//      return _stopTime(index);
//    } else {
//      if (!_isStation) {
//        if (index < position) return _stopTime(_firstIndex - 1);
//        if (index > position) return _stopTime(_firstIndex);
//      } else {
//        if (index == position) return _stopTime(_firstIndex);
//      }
//    }
//    return Container();
//  }
//
//  _onDragUpdate(BuildContext context, DragUpdateDetails update) {
//    RenderBox getBox = context.findRenderObject();
//    double _width = getBox.size.width;
//    var _relation = getBox.globalToLocal(update.globalPosition).dx / _width;
//    if (_relation >= 0.25 && _relation <= 0.75) {
//      var offset = (0.5 - 2 * _relation).abs();
//      int _length = widget.thread.stops.length;
//      int _lookPosition =
//          min((offset * _numberOfDots).round(), _numberOfDots - 1);
//      if (_lookPosition == position) {
//        if (_lookPosition / _numberOfDots > position / _numberOfDots)
//          _lookPosition = min(_numberOfDots, _lookPosition + 1);
//        if (_lookPosition / _numberOfDots < position / _numberOfDots)
//          _lookPosition = max(0, _lookPosition - 1);
//      }
//      _lookStationIndex = min((offset * _length).round(), _length - 1);
//      setState(() {
//        lookPosition = _lookPosition;
//      });
////      print("Station - $_lookStationIndex");
////      print("Position - $_lookPosition\n");
//    }
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return GestureDetector(
//      behavior: HitTestBehavior.translucent,
//      onHorizontalDragUpdate: (update) => _onDragUpdate(context, update),
//      child: Container(
//        padding: EdgeInsets.all(16.0),
//        child: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//          crossAxisAlignment: CrossAxisAlignment.center,
//          mainAxisSize: MainAxisSize.max,
//          children: _buildDots(),
//        ),
//      ),
//    );
//  }
//
//  void _timer() {
//    var _end = widget.thread.stops.last.arrival;
//    var _start = widget.thread.stops.first.departure;
//    var _total = _end.difference(_start).inMinutes;
//    var _now = DateTime.now().toLocal().difference(_start).inMinutes;
//    var _timeRelation = (_now / _total).abs();
//    int _index = 0;
//    _isStation = true;
//    _firstIndex = widget.thread.stops.indexWhere((stop) {
//      var _time = stop.arrival ?? stop.departure;
//      var _diff = -DateTime.now().toLocal().difference(_time).inSeconds;
//      return _diff > 0;
//    });
//    if (_firstIndex > 0) {
//      var stop = widget.thread.stops.elementAt(_firstIndex);
//      var _time = stop.arrival ?? stop.departure;
//      var _diff = -DateTime.now().toLocal().difference(_time).inSeconds;
//      if (_diff > 60) {
//        _isStation = false;
//      }
//      _index = (_timeRelation * _numberOfDots).floor();
//      print(
//          "Time: $_timeRelation - $_index/$_numberOfDots - $_firstIndex/${widget.thread.stops.length}");
//    } else if (_firstIndex < 0) _index = _firstIndex = _numberOfDots;
////    print(_firstIndex);
//    setState(() {
//      position = _index;
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//    position = -1;
//    _firstIndex = -1;
//    Timer(Duration(seconds: 0), _timer);
//    Timer.periodic(Duration(seconds: 10), (timer) => _timer);
//  }
//
//  @override
//  void didUpdateWidget(ThreadIndicator oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (oldWidget.thread != widget.thread) {
//      position = -1;
//      _firstIndex = -1;
//      Timer(Duration(seconds: 0), _timer);
//      Timer.periodic(Duration(seconds: 10), (timer) => _timer);
//    }
//  }
//}
