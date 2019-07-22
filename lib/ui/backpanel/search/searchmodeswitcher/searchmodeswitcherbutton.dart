import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/src/constants.dart';

enum SearchModeButtonType { history, stations, dateTime }

class SearchModeButton extends StatefulWidget {
  final BehaviorSubject<int> currentPage;
  final SearchModeButtonType type;

  const SearchModeButton(
      {Key key, @required this.currentPage, @required this.type})
      : super(key: key);

  @override
  _SearchModeButtonState createState() => _SearchModeButtonState();
}

class _SearchModeButtonState extends State<SearchModeButton> {
  _index() {
    switch (widget.type) {
      case SearchModeButtonType.history:
        return 0;
      case SearchModeButtonType.stations:
        return 1;
      case SearchModeButtonType.dateTime:
        return 2;
    }
  }

  _label() {
    switch (widget.type) {
      case SearchModeButtonType.history:
        return "История";
      case SearchModeButtonType.stations:
        return "Станции";
      case SearchModeButtonType.dateTime:
        return "Время";
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: widget.currentPage.stream,
        builder: (context, snapshot) {
          final selectedIndex = snapshot.hasData ? snapshot.data : -1;
          final pressed = selectedIndex == _index();
          return GestureDetector(
            onTap: () {
              widget.currentPage.sink.add(_index());
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                color: pressed
                    ? Constants.BACKGROUND_GREY_1DP
                    : Constants.BACKGROUND_GREY_4DP,
                elevation: pressed ? 0.0 : 3.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                    side: pressed
                        ? BorderSide(width: 2.0, color: Constants.accentColor)
                        : BorderSide(style: BorderStyle.none)),
                child: Container(
                  padding: const EdgeInsets.all(8.0),
                  width: 100.0,
                  child: Text(
                    _label(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: pressed
                            ? Constants.TEXT_SIZE_MEDIUM
                            : Constants.TEXT_SIZE_MEDIUM + 1,
                        color: pressed
                            ? Constants.accentColor
                            : Constants.whiteMedium),
                  ),
                ),
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
  }
}
