import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/navbloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/navigation/squirclebutton.dart';

class TopNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navBloc = InheritedBloc.navOf(context);
    return Column(
      children: <Widget>[
        SizedBox(height: MediaQuery.of(context).padding.top),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 140,
          padding: const EdgeInsets.symmetric(horizontal: Constants.PADDING_PAGE),
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
                        outlined: true,
                      ),
                    );
                  case NavState.Station:
                    return Container();
                  // case NavState.Schedule:
                  //   return Align(
                  //     alignment: Alignment.centerRight,
                  //     child: SquircleButton(
                  //       callback: navBloc.pop.value,
                  //       type: ButtonType.Back,
                  //       enabled: true,
                  //       raised: true,
                  //       fab: false,
                  //       outlined: true,
                  //     ),
                  //   );
                  case NavState.Train:
                    return Align(
                      alignment: Alignment.centerRight,
                      child: SquircleButton(
                        callback: navBloc.pop.value,
                        type: ButtonType.Back,
                        enabled: true,
                        raised: true,
                        fab: false,
                        outlined: true,
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
