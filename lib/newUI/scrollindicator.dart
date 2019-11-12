import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';

class ScrollIndicator extends StatefulWidget {
  final Stream<Map<String, int>> stream;

  const ScrollIndicator({Key key, this.stream}) : super(key: key);

  @override
  _ScrollIndicatorState createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<ScrollIndicator> {
  final backgroundHeight = 72.0;
  final backgroundWidth = 12.0;
  final selectedWidth = 8.0;

  Widget _background() {
    return Container(
      height: backgroundHeight,
      width: backgroundWidth,
      alignment: Alignment.center,
      child: Container(
        width: backgroundWidth / 2,
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(backgroundWidth / 2)),
          color: Constants.SECONDARY,
        ),
      ),
    );
  }

  Widget _path(selectedHeight) {
    return Container(
      height: selectedHeight,
      width: selectedWidth,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(selectedWidth / 2)),
        color: Constants.PRIMARY,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final distance = (backgroundWidth - selectedWidth) / 2;
    return Stack(
      children: <Widget>[
        _background(),
        StreamBuilder<Map<String, int>>(
            stream: widget.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Container();
              final total = snapshot.data['total'];
              final current = snapshot.data['current'];
              final selectedHeight = backgroundHeight / (total - 2);
              return Positioned(
                child: _path(selectedHeight),
                left: distance,
                right: distance,
                top: current * selectedHeight / 2,
              );
            }),
      ],
    );
  }
}
