import 'package:flutter/material.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';
import 'package:trains/newData/blocs/inheritedbloc.dart';
import 'package:trains/newData/blocs/inputtypebloc.dart';
import 'package:trains/newData/blocs/navbloc.dart';
import 'package:trains/newUI/squirclebutton.dart';

class TopNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navBloc = InheritedBloc.navOf(context);
    final searchBloc = InheritedBloc.searchOf(context);
    return Column(
      children: <Widget>[
        Container(height: MediaQuery.of(context).padding.top),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 124,
          child: StreamBuilder<NavState>(
              stream: navBloc.state.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                switch (snapshot.data) {
                  case NavState.Main:
                    return Container();
                  case NavState.Search:
                    return Align(
                      alignment: Alignment.centerRight,
                      child: SquircleButton(
                        callback: navBloc.pop.value,
                        type: ButtonType.Back,
                        enabled: true,
                        raised: true,
                        fab: false,
                        top: true,
                      ),
                    );
                  case NavState.Station:
                    return Container();
                  case NavState.Schedule:
                    return Align(
                      alignment: Alignment.centerRight,
                      child: SquircleButton(
                        callback: navBloc.pop.value,
                        type: ButtonType.Back,
                        enabled: true,
                        raised: true,
                        fab: false,
                        top: true,
                      ),
                    );
                  case NavState.Train:
                    return Align(
                      alignment: Alignment.centerRight,
                      child: SquircleButton(
                        callback: navBloc.pop.value,
                        type: ButtonType.Back,
                        enabled: true,
                        raised: true,
                        fab: false,
                        top: true,
                      ),
                    );
                }
                return Container();
              }),
        ),
      ],
    );
  }
}
