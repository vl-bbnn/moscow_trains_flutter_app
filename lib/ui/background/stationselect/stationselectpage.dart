import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/src/constants.dart';
import 'dart:math';

import 'package:trains/ui/res/stationcard.dart';

class StationSelectPage extends StatefulWidget {
  @override
  _StationSelectPageState createState() => _StationSelectPageState();
}

class _StationSelectPageState extends State<StationSelectPage>
    with WidgetsBindingObserver {
  var keyboardVisible = false;
  var oldOffset = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navBloc = InheritedBloc.navOf(context);
    final typingSuggestionsBloc = InheritedBloc.typingOf(context);
    final focusNode = typingSuggestionsBloc.focusNode;
    navBloc.focus.add(focusNode);
    final cornerRadius = 28.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          height: 50,
        ),
        Container(
          height: 100,
          width: Constants.STATIONCARD_WIDTH + Constants.PADDING_BIG * 2,
          alignment: Alignment.center,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              TextField(
                  controller: typingSuggestionsBloc.textfield,
                  autofocus: true,
                  focusNode: focusNode,
                  textCapitalization: TextCapitalization.words,
                  cursorColor: Constants.PRIMARY,
                  cursorWidth: 3,
                  keyboardType: TextInputType.text,
                  style: Theme.of(context).textTheme.title,
                  decoration: InputDecoration(
                    hintText: "Найти станцию",
                    hintStyle: TextStyle(
                        fontSize: 16,
                        fontFamily: "Montserrat",
                        fontWeight: FontWeight.bold,
                        color: Constants.GREY),
                    contentPadding: const EdgeInsets.all(Constants.PADDING_BIG),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid,
                            width: 3,
                            color: Constants.SECONDARY),
                        borderRadius:
                            BorderRadius.all(Radius.circular(cornerRadius))),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            style: BorderStyle.solid,
                            width: 3,
                            color: Constants.PRIMARY),
                        borderRadius:
                            BorderRadius.all(Radius.circular(cornerRadius))),
                    // filled: true,
                    // fillColor: Constants.SECONDARY,
                  )),
              Align(
                alignment: Alignment.centerRight,
                child: StreamBuilder<List<Station>>(
                    stream: typingSuggestionsBloc.typingList,
                    builder: (context, snapshot) {
                      final empty = !snapshot.hasData || snapshot.data.isEmpty;
                      return GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: 75,
                          height: 75,
                          padding:
                              const EdgeInsets.all(Constants.PADDING_REGULAR),
                          child: Icon(
                            empty ? Icons.arrow_back : Icons.close,
                            size: 24,
                            color: Constants.GREY,
                          ),
                        ),
                        onTap: () {
                          if (empty)
                            navBloc.pop.value();
                          else
                            typingSuggestionsBloc.clear();
                        },
                      );
                    }),
              ),
            ],
          ),
        ),
        Expanded(
            child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onPanDown: (_) {
            focusNode?.unfocus();
          },
          child: Container(
            width: 250,
            alignment: Alignment.center,
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                final offset = typingSuggestionsBloc.scroll.offset;
                if (notification is ScrollStartNotification) {
                  oldOffset = offset;
                } else if (notification is ScrollEndNotification) {
                  final maxOffset =
                      typingSuggestionsBloc.scroll.position.maxScrollExtent;
                  final atTop = (oldOffset == 0 && offset == 0);
                  final afterEnd =
                      (oldOffset == maxOffset && offset == maxOffset);
                  if (afterEnd || atTop) focusNode?.requestFocus();
                }
                return false;
              },
              child: StreamBuilder<List<Station>>(
                  stream: typingSuggestionsBloc.suggestions,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) return Container();
                    return ListView(
                      controller: typingSuggestionsBloc.scroll,
                      children: snapshot.data
                          .sublist(0, min(10, snapshot.data.length))
                          .map((station) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: Constants.PADDING_SMALL),
                                child: GestureDetector(
                                  onTap: () {
                                    typingSuggestionsBloc
                                        .updateStation(station);
                                    navBloc.pop.value();
                                  },
                                  behavior: HitTestBehavior.translucent,
                                  child: StationCard(
                                    station: station,
                                  ),
                                ),
                              ))
                          .toList(),
                    );
                  }),
            ),
          ),
        )),
      ],
    );
  }

  @override
  void didChangeMetrics() {
    setState(() {
      keyboardVisible = window.viewInsets.bottom > 0;
    });
  }
}
