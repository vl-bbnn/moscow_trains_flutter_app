import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/data/blocs/appnavigationbloc.dart';
import 'package:trains/data/blocs/globalvalues.dart';
import 'package:trains/ui/common/mycolors.dart';
import 'package:trains/ui/schedulepage/navpanel.dart';
import 'package:trains/ui/stationselectpage/stationinput.dart';

class BottomPanel extends StatefulWidget {
  final List<AppState> appStates;

  const BottomPanel({Key key, this.appStates}) : super(key: key);

  @override
  _BottomPanelState createState() => _BottomPanelState();
}

class _BottomPanelState extends State<BottomPanel> with WidgetsBindingObserver {
  final key = GlobalKey();
  double overlap;
  bool keyboardVisible;

  @override
  void initState() {
    super.initState();
    keyboardVisible = false;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final renderBox = (key.currentContext.findRenderObject() as RenderBox);
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final size = MediaQuery.of(context).size;

    if (this.mounted)
      setState(() {
        keyboardVisible = widgetRect.bottom != keyboardTopPoints;
        overlap = (widgetRect.bottom - keyboardTopPoints).clamp(
            MediaQuery.of(context).viewPadding.bottom + Helper.height(20, size),
            size.height);
      });
  }

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalValues.of(context);
    final size = MediaQuery.of(context).size;
    AppState oldAppState = AppState.Launch;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
        child: Container(
          color: MyColors.BACK_EL.withOpacity(0.75),
          child: AnimatedContainer(
            key: key,
            duration: Duration(milliseconds: 500),
            height: Helper.height(98, size) +
                (keyboardVisible
                    ? overlap
                    : MediaQuery.of(context).viewPadding.bottom),
            curve: Curves.easeInOut,
            // color: MyColors.BACK_EL,
            child: StreamBuilder<AppState>(
                stream: globalValues.appNavigationBloc.currentAppState,
                builder: (context, currentAppStateSnapshot) {
                  // print("Bottom Panel: " +
                  //     currentAppStateSnapshot.data.toString());
                  final newAppState = currentAppStateSnapshot.hasData
                      ? currentAppStateSnapshot.data
                      : oldAppState;
                  oldAppState = newAppState;
                  switch (newAppState) {
                    case AppState.Launch:
                      return Container();
                    case AppState.Schedule:
                      return NavigationButtons();
                    case AppState.StationSelect:
                      return StationInput();
                  }
                  return Container();
                }),
          ),
        ),
      ),
    );
  }
}
