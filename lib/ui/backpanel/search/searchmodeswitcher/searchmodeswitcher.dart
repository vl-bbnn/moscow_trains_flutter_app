import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/search/searchmodeswitcher/searchmodeswitcherbutton.dart';

class SearchModeSwitcher extends StatefulWidget {
  final BehaviorSubject<int> currentPage;

  const SearchModeSwitcher({Key key, @required this.currentPage})
      : super(key: key);

  @override
  _SearchModeSwitcherState createState() => _SearchModeSwitcherState();
}

class _SearchModeSwitcherState extends State<SearchModeSwitcher> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(top: 18.0, bottom: 8.0, left: 8.0, right: 8.0),
      child: Material(
        color: Constants.BACKGROUND_DARK_GREY,
        elevation: 0.0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Padding(
          padding: const EdgeInsets.all(1.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SearchModeButton(
                type: SearchModeButtonType.history,
                currentPage: widget.currentPage,
              ),
              SearchModeButton(
                type: SearchModeButtonType.stations,
                currentPage: widget.currentPage,
              ),
              SearchModeButton(
                type: SearchModeButtonType.dateTime,
                currentPage: widget.currentPage,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
