import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/trainsbloc.dart';
import 'package:trains/data/blocs/uibloc.dart';
import 'package:trains/data/classes/suggestion.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class InputTitle extends StatelessWidget {
  final InputType type;

  const InputTitle({Key key, this.type}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    var label = (type == InputType.from)
        ? "Откуда -"
        : (type == InputType.to) ? "Куда" : "";
    SearchParameter key;
    if (type == InputType.from)
      key = SearchParameter.from;
    else if (type == InputType.to) key = SearchParameter.to;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: StreamBuilder<Map<SearchParameter, Object>>(
          stream: trainsBloc.searchParametersStream,
          builder: (context, parameters) {
            if (parameters.hasData) {
              var suggestion = parameters.data[key] as Station;
              if (suggestion != null) {
                var labeled = suggestion.label != Label.other;
                return Row(
                  children: <Widget>[
                    Text(
                      "${suggestion.station.name}",
                      style: TextStyle(
                          color: Constants.whiteHigh,
                          fontSize: Constants.TEXT_SIZE_BIG,
                          fontWeight: FontWeight.bold),
                    ),
                    labeled
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Icon(
                              Helper.suggestionIconData(suggestion.label),
                              color: Constants.accentColor,
                              size: Constants.TEXT_SIZE_BIG,
                            ),
                          )
                        : Container(),
                    type == InputType.from
                        ? Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Text(
                              "-",
                              style: TextStyle(
                                  color: Constants.whiteHigh,
                                  fontSize: Constants.TEXT_SIZE_BIG,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : Container(),
                  ],
                );
              }
            }
            return Text(
              label,
              style: TextStyle(
                  color: Constants.whiteMedium,
                  fontSize: Constants.TEXT_SIZE_BIG,
                  fontWeight: FontWeight.bold),
            );
          }),
    );
  }
}
