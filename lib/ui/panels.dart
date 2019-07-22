import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/backpanel/backpanel.dart';
import 'package:trains/ui/frontpanel/frontpanel.dart';
import 'package:trains/ui/frontpanelheader/frontpanelheader.dart';
import 'package:trains/ui/src/backdrop.dart';

class Panels extends StatelessWidget {
  final frontPanelVisible = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    final uiBloc = InheritedBloc.uiOf(context);
    frontPanelVisible.addListener(
        () => uiBloc.frontPanelOpenSink.add(frontPanelVisible.value));
    return StreamBuilder<bool>(
        stream: uiBloc.frontPanelOpenStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) frontPanelVisible.value = snapshot.data;
          return Backdrop(
            frontLayer: FrontPanel(),
            backLayer: BackPanel(),
            frontHeader: FrontPanelHeader(),
            panelVisible: frontPanelVisible,
            frontHeaderHeight: 135.0,
            frontPanelOpenHeight: 70.0,
            frontPanelPadding: EdgeInsets.all(0.0),
            frontHeaderVisibleClosed: true,
          );
        });
  }
}
