import 'package:flutter/material.dart';
import 'package:trains/data/blocs/frontpanelbloc.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/res/searchstations.dart';
import 'package:trains/ui/search/searchpanel.dart';
import 'package:trains/ui/stationselect/stationselectpanel.dart';

class FrontPanel extends StatefulWidget {
  @override
  _FrontPanelState createState() => _FrontPanelState();
}

class _FrontPanelState extends State<FrontPanel>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Animation _animation;
  var _prevState;

  @override
  initState() {
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller);
    super.initState();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    // print("Build");
    final navBloc = InheritedBloc.frontPanelBloc;
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
          color: Constants.ELEVATED_1,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(28), topRight: Radius.circular(28)),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 30,
            child: Center(
              child: Container(
                width: 50,
                height: 6,
                decoration: ShapeDecoration(
                    color: Constants.BACKGROUND,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(3),
                    )),
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: FadeTransition(
              opacity: _animation,
              child: StreamBuilder<FrontPanelState>(
                  stream: navBloc.state.stream,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    if (snapshot.data != _prevState) {
                      _controller.reset();
                      _prevState = snapshot.data;
                    }
                    _controller.forward();
                    // print("Switch");
                    switch (snapshot.data) {
                      case FrontPanelState.Search:
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SearchStations(),
                            // StreamBuilder<double>(
                            //     stream: navBloc.panelSlide,
                            //     builder: (context, panelSlideStream) {
                            //       final panelSlide = panelSlideStream.data ?? 0;
                            //       return Opacity(
                            //           opacity: panelSlide,
                            //           child: SearchPanel());
                            //     }),
                          ],
                        );
                      case FrontPanelState.StationSelect:
                        return StationSelectPanel();
                    }
                    return Container();
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
