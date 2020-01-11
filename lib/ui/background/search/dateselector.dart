import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class DateSelector extends StatelessWidget {
  const DateSelector({Key key, this.size}) : super(key: key);

  final double size;

  final width = Constants.DATECARD_WIDTH;
  final height = Constants.DATECARD_HEIGHT;

  @override
  Widget build(BuildContext context) {
    final dateBloc = InheritedBloc.dateOf(context);
    final listviewEndPadding = width * 2;
    dateBloc.rebuilt();
    return Container(
      width: size,
      height: height + Constants.PADDING_REGULAR * 2,
      child: Row(
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: Constants.PADDING_BIG),
            child: StreamBuilder<DateTime>(
                stream: dateBloc.selected,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Container();
                  return DateCardSelected(
                    date: snapshot.data,
                  );
                }),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                Container(
                    height: height,
                    child: StreamBuilder<List<DateTime>>(
                        stream: dateBloc.list.stream,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Container();
                          return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: snapshot.data.length,
                              physics: NeverScrollableScrollPhysics(),
                              controller: dateBloc.scroll,
                              itemBuilder: (context, index) {
                                final date = snapshot.data.elementAt(index);
                                if (date == null)
                                  return Container(
                                    width: listviewEndPadding,
                                  );
                                else
                                  return DateCardRegular(
                                    date: date,
                                  );
                              });
                        })),
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                            stops: [
                          0,
                          0.25
                        ],
                            colors: [
                          Constants.BLACK,
                          Colors.transparent,
                        ])),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DateCardSelected extends StatelessWidget {
  final DateTime date;

  const DateCardSelected({Key key, @required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Constants.PADDING_REGULAR),
      child: Container(
        alignment: Alignment.centerLeft,
        height: Constants.DATECARD_HEIGHT,
        child: Text(
          date.day.toString() + " " + Helper.month(date.month)['cased'],
          style: TextStyle(
            color: Constants.WHITE,
            fontFamily: "Montserrat",
            fontWeight: FontWeight.w600,
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}

class DateCardRegular extends StatelessWidget {
  final DateTime date;

  const DateCardRegular({Key key, @required this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Constants.DATECARD_WIDTH,
      height: Constants.DATECARD_HEIGHT,
      child: Center(
        child: Text(
          date.day.toString(),
          style: TextStyle(
            color: Constants.DARKGREY,
            fontFamily: "LexendDeca",
            fontSize: 30,
          ),
        ),
      ),
    );
  }
}
