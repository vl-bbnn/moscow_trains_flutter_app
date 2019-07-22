import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/classes/suggestion.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class SuggestionButton extends StatelessWidget {
  final Suggestion suggestion;

  const SuggestionButton({Key key, @required this.suggestion})
      : super(key: key);

  _textSize() {
    if (suggestion.station.name.length < 11)
      return Constants.TEXT_SIZE_MEDIUM;
    else if (suggestion.station.name.length < 13)
      return Constants.TEXT_SIZE_MEDIUM - 1;
    else
      return Constants.TEXT_SIZE_MEDIUM - 2;
  }

  @override
  Widget build(BuildContext context) {
    final stationsBloc = InheritedBloc.stationsOf(context);
    final labeled = suggestion.label != null && suggestion.label != Label.other;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        stationsBloc.updateStation(suggestion);
      },
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          color: Constants.BACKGROUND_GREY_1DP,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
              side: BorderSide(width: 1.5, color: Constants.whiteDisabled)),
          elevation: 0.0,
          child: Container(
            width: labeled ? 170.0 : 150.0,
            height: 40.0,
            padding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    suggestion.station.name,
                    style: TextStyle(
                        color: Constants.whiteMedium,
                        fontSize: _textSize(),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                labeled
                    ? Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Icon(
                              Helper.suggestionIconData(suggestion.label),
                              color: Constants.accentColor,
                              size: _textSize(),
                            ),
                          ),
                          suggestion.label == Label.closest
                              ? Padding(
                                  padding: const EdgeInsets.all(2.0),
                                  child: Text(
                                    Helper.shortMetersText(
                                        int.parse(suggestion.text))["full"],
                                    style: TextStyle(
                                        color: Constants.whiteMedium,
                                        fontWeight: FontWeight.w600,
                                        fontSize: _textSize() - 2),
                                  ),
                                )
                              : Container(),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
