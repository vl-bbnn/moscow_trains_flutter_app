import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/uibloc.dart';
import 'package:trains/data/src/constants.dart';

class SearchButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.trainsOf(context);
    final uiBloc = InheritedBloc.uiOf(context);
    return StreamBuilder<bool>(
      stream: trainsBloc.readyToSearchStream,
      builder: (context, ready) {
        var search = ready.hasData && ready.data;
        if (search) FocusScope.of(context).unfocus();
        return FloatingActionButton(
          onPressed: () {
            if (search) {
              trainsBloc.fetch();
              FocusScope.of(context).unfocus();
              uiBloc.frontPanelOpenSink.add(true);
              trainsBloc.readyToSearchSink.add(false);
            }
          },
          backgroundColor: Constants.BACKGROUND_GREY_8DP,
          child: Icon(
            search ? Icons.search : Icons.mic,
            color: Constants.accentColor,
            size: Constants.TEXT_SIZE_MAX,
          ),
        );
      },
    );
  }
}
