import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/stationsbloc.dart';
import 'package:trains/data/blocs/uibloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/frontpanelheader/title/searchbutton.dart';
import 'package:trains/ui/frontpanelheader/title/inputtitle.dart';
import 'package:trains/ui/frontpanelheader/title/selecteddatetimetitle.dart';

class FrontPanelHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiBloc = InheritedBloc.uiOf(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        uiBloc.backPanelTypeSink.add(BackPanelType.search);
        uiBloc.frontPanelOpenSink.add(false);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 18.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(2.0),
              alignment: Alignment.center,
              child: Material(
                color: Constants.whiteDisabled,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0)),
                elevation: 0.0,
                child: Container(
                  width: 25.0,
                  height: 4.0,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    InputTitle(type: InputType.from),
                    InputTitle(type: InputType.to),
                  ],
                ),
                SearchButton(),
              ],
            ),
            SelectedDateTimeTitle(),
          ],
        ),
      ),
    );
  }
}
