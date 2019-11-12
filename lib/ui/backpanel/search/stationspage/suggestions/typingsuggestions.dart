import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/classes/suggestion.dart';
import 'package:trains/ui/backpanel/search/stationspage/suggestions/suggestionbutton.dart';
import 'package:trains/ui/screens/errorscreen.dart';

class TypingSuggestions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final stationsBloc = InheritedBloc.stationsOf(context);
    return StreamBuilder<List<Station>>(
      stream: stationsBloc.typingSuggestionsStream,
      builder: (context, snapshot) {
        if (snapshot.hasError) return ErrorScreen();
        if (!snapshot.hasData || snapshot.data.length < 2) return Container();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SuggestionButton(
              suggestion: snapshot.data.elementAt(0),
            ),
//            Padding(
//              padding: const EdgeInsets.symmetric(horizontal: 8.0),
//              child: Container(
//                height: 25.0,
//                width: 3.0,
//                child: Material(
//                  color: Constants.accentColor,
//                  elevation: 3.0,
//                  shape: RoundedRectangleBorder(
//                      borderRadius: BorderRadius.circular(3.0)),
//                ),
//              ),
//            ),
            SuggestionButton(
              suggestion: snapshot.data.elementAt(1),
            ),
          ],
        );
      },
    );
  }
}
