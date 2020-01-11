import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/blocs/navbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/navigation/squirclebutton.dart';
import 'package:trains/ui/res/stationcard.dart';

class SelectedStationsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final navBloc = InheritedBloc.navOf(context);
    final searchBloc = InheritedBloc.searchOf(context);
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: ShapeDecoration(
          color: Constants.SECONDARY,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(38.5),
                  topRight: Radius.circular(38.5)))),
      padding: const EdgeInsets.symmetric(
          horizontal: Constants.PADDING_PAGE),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    StreamBuilder<Station>(
                        stream: searchBloc.fromStation,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return Text(
                            snapshot.data.name + " -",
                            style: Theme.of(context).textTheme.title,
                          );
                        }),
                    StreamBuilder<Station>(
                        stream: searchBloc.toStation,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return Text(
                            snapshot.data.name,
                            style: Theme.of(context).textTheme.title,
                          );
                        }),
                  ],
                ),
                SquircleButton(
                  callback: () => navBloc.state.add(NavState.Search),
                  type: ButtonType.Search,
                  outlined: false,
                  enabled: true,
                  raised: true,
                  fab: true,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          )
        ],
      ),
    );
  }
}
