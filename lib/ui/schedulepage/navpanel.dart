import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/ui/common/customicon.dart';

class NavigationButtons extends StatelessWidget {
  final Sizes sizes;

  const NavigationButtons({Key key, this.sizes}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalBloc.of(context);
    return Padding(
      padding: EdgeInsets.fromLTRB(
          sizes.navPanelInnerHorizontalPadding,
          sizes.navPanelInnerTopPadding,
          sizes.navPanelInnerHorizontalPadding,
          sizes.navPanelInnerBottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomIcon(type: Type.bookmarks, size: sizes.navPanelIconSize),
          GestureDetector(
              onTap: () {
                globalValues.searchBloc.switchInputs();
              },
              child:
                  CustomIcon(type: Type.arrows, size: sizes.navPanelIconSize)),
          CustomIcon(type: Type.people, size: sizes.navPanelIconSize),
        ],
      ),
    );
  }
}
