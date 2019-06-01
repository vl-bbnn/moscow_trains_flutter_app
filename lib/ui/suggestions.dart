import 'package:flutter/material.dart';
import 'package:trains/data/Inheritedbloc.dart';
import 'package:trains/data/bloc.dart';
import 'package:trains/data/station.dart';

class Suggestions extends StatelessWidget {
  Suggestions(this.type);

  final InputType type;

  @override
  Widget build(BuildContext context) {
    final trainsBloc = InheritedBloc.of(context);
    return StreamBuilder<List<Station>>(
      stream: trainsBloc.suggestions,
      builder: (context, snapshot) {
        if (snapshot.hasError) return Text('Error: ${snapshot.error}');
        return Container(
          padding: EdgeInsets.only(top: 18.0),
          child: (snapshot.data != null && snapshot.data.length > 1)
              ? Wrap(
                  alignment: WrapAlignment.spaceEvenly,
                  children: snapshot.data.map((station) {
                    return GestureDetector(
                      onTap: () {
                        switch (type) {
                          case InputType.from:
                            {
                              trainsBloc.setFromStation.add(station);
                              break;
                            }
                          case InputType.to:
                            {
                              trainsBloc.setToStation.add(station);
                              break;
                            }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 4.0),
                        child: Text(
                          station.name,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    );
                  }).toList(),
                )
              : Container(),
        );
      },
    );
  }
}
