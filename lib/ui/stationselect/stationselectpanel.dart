import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/src/constants.dart';
import 'package:trains/ui/res/stationcard.dart';
import 'package:trains/ui/stationselect/inputselector.dart';

class StationSelectPanel extends StatefulWidget {
  @override
  _StationSelectPanelState createState() => _StationSelectPanelState();
}

class _StationSelectPanelState extends State<StationSelectPanel>
    with WidgetsBindingObserver {
  final _columnKey = GlobalKey();

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
  void didChangeMetrics() {
    final renderBox = (context.findRenderObject() as RenderBox);
    final offset = renderBox.localToGlobal(Offset.zero);
    final widgetRect = Rect.fromLTWH(
      offset.dx,
      offset.dy,
      renderBox.size.width,
      renderBox.size.height,
    );
    final keyboardTopPixels =
        window.physicalSize.height - window.viewInsets.bottom;
    final keyboardTopPoints = keyboardTopPixels / window.devicePixelRatio;
    final overlap =
        max(0, (widgetRect.bottom - keyboardTopPoints).round() - 30);
    final widgetBox =
        (_columnKey.currentContext.findRenderObject() as RenderBox);
    print("Height: " + widgetBox.size.height.toString());
    print("Overlap: " + overlap.toString());
    InheritedBloc.frontPanelBloc.stationSelectPanelHeight
        .add(widgetBox.size.height + overlap + 100);
  }

  // _updatePanelHeight(context) {
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     final renderBox = (context.findRenderObject() as RenderBox);
  //     print("OLD Height: " + renderBox.size.height.toString());
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final navBloc = InheritedBloc.frontPanelBloc;
    navBloc.focus.add(InheritedBloc.typingSuggestionsBloc.focusNode);
    // _updatePanelHeight(context);
    return StreamBuilder<List<Station>>(
        stream: InheritedBloc.typingSuggestionsBloc.suggestions,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final list = snapshot.data.sublist(0, min(2, snapshot.data.length));
          return Column(
            children: <Widget>[
              Column(
                key: _columnKey,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    constraints: BoxConstraints(maxHeight: 193),
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: list
                          .map((station) => GestureDetector(
                                onTap: () {
                                  InheritedBloc.typingSuggestionsBloc
                                      .updateStation(station);
                                  navBloc.panelClose.value();
                                },
                                behavior: HitTestBehavior.translucent,
                                child: StationCard(
                                  station: station,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      decoration: ShapeDecoration(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                              side: BorderSide(
                                  color: Constants.ELEVATED_2, width: 3))),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 17, vertical: 12),
                      child: Column(
                        children: <Widget>[
                          InputSelector(
                            inputType: InputType.Station,
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    width: 36,
                                    height: 36,
                                    child: Center(
                                      child: Icon(
                                        Icons.arrow_back,
                                        size: 24,
                                        color: Constants.GREY,
                                      ),
                                    ),
                                  ),
                                  onTap: () => InheritedBloc
                                      .frontPanelBloc.panelClose
                                      .value()),
                              Center(
                                child: Container(
                                  decoration: ShapeDecoration(
                                      color: Constants.ELEVATED_3,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(
                                          width: 95,
                                          child: TextField(
                                            textAlign: TextAlign.center,
                                            autofocus: true,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            focusNode: InheritedBloc
                                                .typingSuggestionsBloc
                                                .focusNode,
                                            textCapitalization:
                                                TextCapitalization.characters,
                                            cursorColor: Constants.ELEVATED_2,
                                            cursorWidth: 3,
                                            keyboardType: TextInputType.text,
                                            style: TextStyle(
                                                color: Constants.WHITE,
                                                fontSize: 14,
                                                fontFamily: "PT Root UI",
                                                fontWeight: FontWeight.w500),
                                            controller: InheritedBloc
                                                .typingSuggestionsBloc
                                                .textfield,
                                            decoration: null,
                                          ),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        GestureDetector(
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              width: 18,
                                              height: 18,
                                              child: InheritedBloc
                                                      .typingSuggestionsBloc
                                                      .textfield
                                                      .text
                                                      .isNotEmpty
                                                  ? Center(
                                                      child: Icon(
                                                        Icons.close,
                                                        size: 18,
                                                        color: Constants.GREY,
                                                      ),
                                                    )
                                                  : Container(),
                                            ),
                                            onTap: () => InheritedBloc
                                                .typingSuggestionsBloc
                                                .clear()),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                  behavior: HitTestBehavior.opaque,
                                  child: Container(
                                    // decoration: ShapeDecoration(
                                    //     color: Constants.SECONDARY,
                                    //     shape: RoundedRectangleBorder(
                                    //         borderRadius: BorderRadius.circular(10),
                                    //         side: BorderSide(
                                    //             color: Constants.GREY,
                                    //             width: 1.5))),
                                    width: 36,
                                    height: 36,
                                    child: Center(
                                      child: Icon(
                                        Icons.done,
                                        size: 24,
                                        color: Constants.WHITE,
                                      ),
                                    ),
                                  ),
                                  onTap: () {
                                    InheritedBloc.typingSuggestionsBloc
                                        .updateStation(list.elementAt(0));
                                    navBloc.panelClose.value();
                                  }),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Expanded(
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  color: Constants.ELEVATED_1,
                ),
              )
            ],
          );
        });
  }
}
