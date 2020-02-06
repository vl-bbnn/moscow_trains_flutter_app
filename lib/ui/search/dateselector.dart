import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/data/src/helper.dart';

class DateSelector extends StatelessWidget {
  _getHeight(context) {
    // print("Search Panel size update");
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // final renderBox = (context.findRenderObject() as RenderBox);
      // print("Date Selector Height: " + renderBox.size.height.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    final dateTimeBloc = InheritedBloc.dateTimeBloc;
    dateTimeBloc.rebuiltDateSelector();
    var horizontalStartPosition = 0.0;
    var horizontalInitialOffset = 0.0;
    _getHeight(context);
    return Container(
      decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
        side: BorderSide(color: Constants.ELEVATED_2, width: 3),
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(18), bottomLeft: Radius.circular(18)),
      )),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: StreamBuilder<DateTime>(
          stream: InheritedBloc.searchBloc.dateTime,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Container();
            return Padding(
              padding: const EdgeInsets.only(left: 17),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 35),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          Helper.weekday(snapshot.data.weekday)['full']
                              .toUpperCase(),
                          style: Theme.of(context)
                              .textTheme
                              .headline2
                              .copyWith(color: Constants.WHITE),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              Helper.month(snapshot.data.month)['regular']
                                  .toUpperCase(),
                              style: Theme.of(context)
                                  .textTheme
                                  .headline2
                                  .copyWith(color: Constants.GREY),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.calendar_today,
                              size: 24,
                              color: Constants.WHITE,
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    // onTapDown: (details) async {
                    //   dateTimeBloc.shouldUpdateDate.add(false);
                    //   final newOffset = dateTimeBloc.datesScroll.offset +
                    //       details.localPosition.dx;
                    //   await dateTimeBloc.scrollToOffsetDateSelector(newOffset);
                    //   await dateTimeBloc.roundDateSelector();
                    // },
                    // onTapUp: (details) async {
                    //   InheritedBloc.searchBloc.search();
                    // },
                    // onHorizontalDragDown: (details) {
                    //   horizontalStartPosition = details.localPosition.dx;
                    //   horizontalInitialOffset = dateTimeBloc.datesScroll.offset;
                    //   dateTimeBloc.shouldUpdateDate.add(false);
                    // },
                    // onHorizontalDragUpdate: (details) {
                    //   final newOffset = horizontalInitialOffset +
                    //       (horizontalStartPosition - details.localPosition.dx);
                    //   dateTimeBloc.jumpToOffsetDateSelector(newOffset);
                    // },
                    // onHorizontalDragEnd: (details) {
                    //   dateTimeBloc.roundDateSelector();
                    //   InheritedBloc.searchBloc.search();
                    // },
                    child: Container(
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                        side: BorderSide(color: Constants.ELEVATED_3, width: 2),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(16),
                            bottomLeft: Radius.circular(16)),
                      )),
                      padding:
                          const EdgeInsets.only(left: 3, top: 3, bottom: 3),
                      height: Constants.SELECTED_DATE_HEIGHT + 10,
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            behavior: HitTestBehavior.translucent,
                            onTap: () => InheritedBloc.dateTimeBloc.resetDate(),
                            child: DateCard(
                              date: snapshot.data,
                              selected: true,
                            ),
                          ),
                          Expanded(
                            child: StreamBuilder<List<DateTime>>(
                                stream: dateTimeBloc.datesList.stream,
                                builder: (context, snapshot) {
                                  if (!snapshot.hasData)
                                    return Container(
                                      color: Colors.teal,
                                    );
                                  return NotificationListener<
                                      ScrollNotification>(
                                    onNotification: (scrollNotification) {
                                      if (scrollNotification
                                          is ScrollStartNotification) {
                                        dateTimeBloc.todayIsSelected
                                            .add(false);
                                      } else if (scrollNotification
                                          is ScrollUpdateNotification) {
                                        dateTimeBloc.datesOffset.add(
                                            scrollNotification.metrics.pixels);
                                        dateTimeBloc.selectDate();
                                      } else if (scrollNotification
                                          is ScrollEndNotification) {
                                        dateTimeBloc.roundDateSelector();
                                        InheritedBloc.searchBloc.search();
                                      }
                                      return false;
                                    },
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        controller: dateTimeBloc.datesScroll,
                                        itemBuilder: (context, index) {
                                          final date =
                                              snapshot.data.elementAt(index);
                                          return Row(
                                            children: <Widget>[
                                              SizedBox(
                                                width: 20,
                                              ),
                                              DateCard(
                                                date: date,
                                                selected: false,
                                              ),
                                            ],
                                          );
                                        }),
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }
}

class DateCard extends StatelessWidget {
  final DateTime date;
  final selected;

  const DateCard({Key key, @required this.date, @required this.selected})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    if (selected)
      return Material(
        elevation: 4.0,
        color: Constants.ELEVATED_3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Container(
          width: Constants.SELECTED_DATE_WIDTH,
          height: Constants.SELECTED_DATE_HEIGHT,
          child: Center(
            child: Text(
              date.day.toString(),
              style: TextStyle(
                color: Constants.WHITE,
                fontFamily: "Moscow Sans",
                fontSize: 22,
              ),
            ),
          ),
        ),
      );
    return Container(
      width: Constants.DATE_WIDTH,
      height: Constants.DATE_HEIGHT,
      child: Center(
        child: Text(
          date.day.toString(),
          style: TextStyle(
            color: Constants.GREY,
            fontFamily: "Moscow Sans",
            fontSize: 22,
          ),
        ),
      ),
    );
  }
}
