import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/classes/suggestion.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/search/stationspage/suggestions/suggestionbutton.dart';
import 'package:trains/ui/screens/errorscreen.dart';

class PersistentSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stationsBloc = InheritedBloc.stationsOf(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
      child: Material(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: StreamBuilder<List<Suggestion>>(
            stream: stationsBloc.persistentSuggestionsStream,
            builder: (context, snapshot) {
              if (snapshot.hasError) return ErrorScreen();
              if (!snapshot.hasData) return Container();
              final leftCount = (snapshot.data.length / 2).round();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder<Suggestion>(
                      stream: stationsBloc.closestSuggestionStream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) return Container();
                        return SuggestionButton(
                          suggestion: snapshot.data,
                        );
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: snapshot.data
                            .sublist(0, leftCount)
                            .map((suggestion) => SuggestionButton(
                                  suggestion: suggestion,
                                ))
                            .toList(),
                      ),
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 8.0),
//              child: Container(
//                height: leftCount * 48.0,
//                width: 3.0,
//                child: Material(
//                  color: Constants.accentColor,
//                  elevation: 3.0,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(3.0)),
//                ),
//              ),
//            ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: snapshot.data
                            .sublist(leftCount, snapshot.data.length)
                            .map((suggestion) => SuggestionButton(
                                  suggestion: suggestion,
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
        color: Constants.BACKGROUND_GREY_1DP,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        elevation: 1.0,
      ),
    );
  }
}
