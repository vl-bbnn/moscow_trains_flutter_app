import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/customicon.dart';
import 'package:trains/ui/common/mysizes.dart';

class NavigationButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    final size = MediaQuery.of(context).size;
    final iconSize = Helper.width(NavPanelSizes.ICON_SIZE, size);
    final horizontalPadding =
        Helper.width(NavPanelSizes.HORIZONTAL_PADDING, size);
    final topPadding = Helper.height(NavPanelSizes.TOP_PADDING, size);
    final bottomPadding = Helper.height(NavPanelSizes.BOTTOM_PADDING, size) +
        MediaQuery.of(context).padding.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(
          horizontalPadding, topPadding, horizontalPadding, bottomPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          CustomIcon(type: Type.bookmarks, size: iconSize),
          GestureDetector(
              onTap: () {
                globalValues.searchBloc.switchInputs();
              },
              child: CustomIcon(type: Type.arrows, size: iconSize)),
          CustomIcon(type: Type.people, size: iconSize),
        ],
      ),
    );
  }
}
