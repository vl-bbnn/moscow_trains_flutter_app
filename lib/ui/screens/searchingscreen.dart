import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';

class SearchingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<double>(
        stream: InheritedBloc.frontPanelBloc.panelMaxHeight,
        builder: (context, panelMaxHeightStream) {
          return StreamBuilder<double>(
              stream: InheritedBloc.frontPanelBloc.panelSlide,
              builder: (context, panelSlideStream) {
                var height = 0.0;
                if (panelMaxHeightStream.hasData && panelSlideStream.hasData)
                  height = panelSlideStream.data * panelMaxHeightStream.data;
                return Column(
                  children: <Widget>[
                    Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CircularProgressIndicator(),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Поиск",
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight: FontWeight.bold,
                                  color: Constants.ELEVATED_2,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    AnimatedContainer(
                      height: height,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 300),
                    )
                  ],
                );
              });
        });
  }
}
