import 'package:flutter/material.dart';
import 'package:trains/data/blocs/Inheritedbloc.dart';
import 'package:trains/data/blocs/uibloc.dart';
import 'package:trains/ui/backpanel/search/backpanelsearch.dart';
import 'package:trains/ui/backpanel/thread/backpanelthread.dart';
import 'package:trains/ui/screens/helloscreen.dart';

class BackPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiBloc = InheritedBloc.uiOf(context);
    return Stack(
      children: <Widget>[
        StreamBuilder<BackPanelType>(
            stream: uiBloc.backPanelTypeStream,
            builder: (context, type) {
              if (!type.hasData)
                return Container();
              else if (type.data == BackPanelType.hello)
                return HelloScreen();
              else
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: _backpanelchild(type.data),
                    ),
                    Container(
                      height: 110.0,
                    ),
                  ],
                );
            }),
      ],
    );
  }

  _backpanelchild(BackPanelType type) {
    switch (type) {
      case BackPanelType.search:
        return BackPanelSearch();
      case BackPanelType.user:
        return Container();
      case BackPanelType.thread:
        return BackPanelThread();
      case BackPanelType.settings:
        return Container();
      default:
        return Container();
    }
  }
}

//import 'package:flutter/material.dart';
//import 'package:trains/ui/backpanel/categories/frontpanel.dart';
//
//class BackPanel extends StatefulWidget {
//  BackPanel({Key key, @required this.frontPanelOpen}) : super(key: key);
//  final ValueNotifier<bool> frontPanelOpen;
//
//  @override
//  _BackPanelState createState() => _BackPanelState();
//}
//
//class _BackPanelState extends State<BackPanel> {
//  bool panelOpen;
//
//  @override
//  void initState() {
//    panelOpen = widget.frontPanelOpen.value;
//    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
//    super.initState();
////    _timer();
//  }
//
////  void _timer() {
////    var seconds = 60 - DateTime.now().second;
////    Future.delayed(
////        Duration(seconds: seconds),
////        () => Timer.periodic(Duration(minutes: 1), (Timer t) {
////              setState(() {});
////            }));
////  }
//
//  void _subscribeToValueNotifier() =>
//      setState(() => panelOpen = widget.frontPanelOpen.value);
//
//  @override
//  void didUpdateWidget(BackPanel oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    oldWidget.frontPanelOpen.removeListener(_subscribeToValueNotifier);
//    widget.frontPanelOpen.addListener(_subscribeToValueNotifier);
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Categories();
//  }
//}
