import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trains/data/src/constants.dart';

class WaveSlider extends StatefulWidget {
  final double sliderWidth;
  final double sliderHeight;
  final Color color;
  final ValueChanged<DateTime> onChanged;
  final ValueChanged<DateTime> onChangeStart;
  final ValueChanged<DateTime> onChangeEnd;
  final DateTime initialDateTime;

  WaveSlider({
    this.sliderWidth = 320.0,
    this.sliderHeight = 130.0,
    this.color = Colors.black,
    this.onChangeEnd,
    this.onChangeStart,
    this.onChanged,
    this.initialDateTime,
  }) : assert(sliderHeight >= 50 && sliderHeight <= 600, onChanged != null);

  @override
  _WaveSliderState createState() => _WaveSliderState();
}

class _WaveSliderState extends State<WaveSlider>
    with SingleTickerProviderStateMixin {
  var _dragPosition = 0.0;
  var _dragPercentage = 0.0;
  var _selected = 0;
  var _point = 0.0;
  var _selectedText = "";
  DateTime _dateTime;
  WaveSliderController _slideController;
  bool shouldUpdate = true;

  @override
  void initState() {
    _point = widget.sliderWidth / 24;
    _update();
    _slideController = WaveSliderController(vsync: this)
      ..addListener(() => setState(() {}));
    super.initState();
  }

  _update() {
    if (shouldUpdate) {
      _dateTime = widget.initialDateTime != null
          ? widget.initialDateTime
          : DateTime.now();
      _selected = ((_dateTime.hour + _dateTime.minute / 60)).round();
      _dragPosition = _selected * _point;
      _dragPercentage = _dragPosition / widget.sliderWidth;
      _selectedText = DateFormat('kk:mm').format(_dateTime);
    }
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  _handleChanged(double value) {
    if (widget.onChanged != null) widget.onChanged(_dateTime);
    var hours = _selected % 24;
    _selectedText = hours < 10 ? "0$hours:00" : "$hours:00";
  }

  _handleChangeStart(double value) {
    if (widget.onChangeStart != null) widget.onChangeStart(_dateTime);
    shouldUpdate = false;
  }

  _handleChangeEnd(double value) {
    setState(() {
      _dateTime = DateTime(
          _dateTime.year, _dateTime.month, _dateTime.day, _selected, 0);
    });
    if (widget.onChangeEnd != null) widget.onChangeEnd(_dateTime);
    shouldUpdate = true;
  }

  void _updateDragPosition(Offset val) {
    double newDragPosition = 0.0;
    if (val.dx <= 0.0) {
      newDragPosition = 0.0;
    } else if (val.dx >= widget.sliderWidth) {
      newDragPosition = widget.sliderWidth;
    } else {
      newDragPosition = (val.dx / _point).floor() * _point;
    }
    setState(() {
      _dragPosition = newDragPosition;
      _dragPercentage = _dragPosition / widget.sliderWidth;
      _selected = (_dragPercentage * 24).round();
    });
  }

  void _onDragStart(BuildContext context, DragStartDetails start) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.globalToLocal(start.globalPosition);
    _slideController.setStateToStart();
    _updateDragPosition(localOffset);
    _handleChangeStart(_dragPercentage);
  }

  void _onDragUpdate(BuildContext context, DragUpdateDetails update) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.globalToLocal(update.globalPosition);
    _slideController.setStateToSliding();
    _updateDragPosition(localOffset);
    _handleChanged(_dragPercentage);
  }

  void _onTapDown(BuildContext context, TapDownDetails update) {
    RenderBox box = context.findRenderObject();
    Offset localOffset = box.globalToLocal(update.globalPosition);
    _updateDragPosition(localOffset);
    _handleChangeEnd(_dragPercentage);
  }

  void _onDragEnd(BuildContext context, DragEndDetails end) {
    _slideController.setStateToStopping();
    setState(() {});
    _handleChangeEnd(_dragPercentage);
  }

  Widget _selectedContainer() {
    return Container(
      width: 6.0,
      height: 24.0,
      child: Material(
        color: Constants.accentColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
            side: BorderSide(width: 1.0, color: Constants.BACKGROUND_GREY_4DP)),
        elevation: 4.0,
      ),
    );
  }

  Widget _noMark(int index) {
    var selected = index == _selected;
    return Container(
      height: widget.sliderHeight / 4,
      alignment: Alignment.center,
      child: selected
          ? _selectedContainer()
          : Container(
              width: 6.0,
              height: 8.0,
            ),
    );
  }

  Widget _oneHourMark(int index) {
    var hours = index % 24;
    var selected = index == _selected;
    return Container(
      width: 14.0,
      height: widget.sliderHeight / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: widget.sliderHeight / 4,
            alignment: Alignment.center,
            child: selected
                ? _selectedContainer()
                : Container(
                    width: 4.0,
                    height: 8.0,
                    child: Material(
                      color: Constants.whiteDisabled,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(2.0)),
                      elevation: 2.0,
                    ),
                  ),
          ),
          Container(
            height: widget.sliderHeight / 4,
            alignment: Alignment.center,
            child: Text(
              hours < 10 ? "0$hours" : "$hours",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: Constants.TEXT_SIZE_SMALL,
                  color: Constants.whiteDisabled),
            ),
          )
        ],
      ),
    );
  }

  Widget _twoHoursMark(int index) {
    var hours = index % 24;
    var selected = index == _selected;
    return Container(
      width: 20.0,
      height: widget.sliderHeight / 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            height: widget.sliderHeight / 4,
            alignment: Alignment.center,
            child: selected
                ? _selectedContainer()
                : Container(
                    width: 4.0,
                    height: 16.0,
                    child: Material(
                      color: Constants.whiteMedium,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(3.0)),
                      elevation: 2.0,
                    ),
                  ),
          ),
          Container(
            alignment: Alignment.center,
            height: widget.sliderHeight / 4,
            child: Text(
              hours < 10 ? "0$hours" : "$hours",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Constants.TEXT_SIZE_MEDIUM,
                  color: Constants.whiteMedium),
            ),
          )
        ],
      ),
    );
  }

  Widget _selectedValue() {
    var _percentage = _dragPercentage * 2 - 1;
    return Container(
      padding: const EdgeInsets.all(8.0),
      alignment: Alignment(_percentage, 0.0),
      child: Material(
        elevation: 4.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: Constants.BACKGROUND_GREY_4DP,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6.0),
          child: Text(
            _selectedText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: Constants.TEXT_SIZE_MEDIUM + 1,
              color: Constants.accentColor,
            ),
          ),
        ),
      ),
    );
  }

  Widget _marks() {
    var list = new Iterable<int>.generate(25);
    return Column(
      children: <Widget>[
        _selectedValue(),
        Row(
          children: list.map((index) => _mark(index)).toList(),
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ],
    );
  }

  Widget _mark(int index) {
    if (index % 4 == 0)
      return _twoHoursMark(index);
    else if (index % 2 == 0) return _oneHourMark(index);
    return _noMark(index);
  }

  @override
  Widget build(BuildContext context) {
    _update();
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      child: Container(
        width: widget.sliderWidth,
        height: widget.sliderHeight,
        child: _marks(),
      ),
      onTapDown: (TapDownDetails update) => _onTapDown(context, update),
      onHorizontalDragStart: (DragStartDetails start) =>
          _onDragStart(context, start),
      onHorizontalDragUpdate: (DragUpdateDetails update) =>
          _onDragUpdate(context, update),
      onHorizontalDragEnd: (DragEndDetails end) => _onDragEnd(context, end),
    );
  }
}

class WaveSliderController extends ChangeNotifier {
  final AnimationController controller;
  SliderState _state = SliderState.resting;

  WaveSliderController({@required TickerProvider vsync})
      : controller = AnimationController(vsync: vsync) {
    controller
      ..addListener(_onProgressUpdate)
      ..addStatusListener(_onStatusUpdate);
  }

  void _onProgressUpdate() {
    notifyListeners();
  }

  void _onStatusUpdate(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _onTransitionCompleted();
    }
  }

  void _onTransitionCompleted() {
    if (_state == SliderState.stopping) {
      setStateToResting();
    }
  }

  double get progress => controller.value;

  SliderState get state => _state;

  void _startAnimation() {
    controller.duration = Duration(milliseconds: 500);
    controller.forward(from: 0.0);
    notifyListeners();
  }

  void setStateToStart() {
    _startAnimation();
    _state = SliderState.starting;
  }

  void setStateToStopping() {
    _startAnimation();
    _state = SliderState.stopping;
  }

  void setStateToSliding() {
    _state = SliderState.sliding;
  }

  void setStateToResting() {
    _state = SliderState.resting;
  }
}

enum SliderState {
  starting,
  resting,
  sliding,
  stopping,
}
