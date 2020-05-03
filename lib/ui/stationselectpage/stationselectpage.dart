import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:trains/data/blocs/globalbloc.dart';
import 'package:trains/data/blocs/sizesbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/common/helper.dart';
import 'package:trains/ui/common/stationcardforselector.dart';

class SuggestionsList extends StatefulWidget {
  final Sizes sizes;

  const SuggestionsList({Key key, this.sizes}) : super(key: key);
  @override
  _SuggestionsListState createState() => _SuggestionsListState();
}

class _SuggestionsListState extends State<SuggestionsList>
    with WidgetsBindingObserver {
  final key = GlobalKey();
  var overlap;
  var keyboardVisible;

  @override
  void initState() {
    super.initState();
    keyboardVisible = false;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    final renderBox = (key.currentContext.findRenderObject() as RenderBox);
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
    final size = MediaQuery.of(context).size;

    keyboardVisible = widgetRect.bottom != keyboardTopPoints;
    overlap = (widgetRect.bottom - keyboardTopPoints).clamp(
        MediaQuery.of(context).viewPadding.bottom + Helper.height(20, size),
        size.height);
  }

  @override
  Widget build(BuildContext context) {
    final globalValues = GlobalBloc.of(context);
    final suggestionsBloc = globalValues.suggestionsBloc;
    final size = MediaQuery.of(context).size;
    double oldPageValue = 0.0;
    return Column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          height: MediaQuery.of(context).padding.top + Helper.height(30, size),
        ),
        Expanded(
          child: Container(
            width: size.width,
            padding: EdgeInsets.symmetric(horizontal: Helper.width(35, size)),
            child: StreamBuilder<List<Station>>(
                stream: suggestionsBloc.suggestions,
                builder: (context, suggestionsSnapshot) {
                  print("suggestions list");
                  if (!suggestionsSnapshot.hasData ||
                      suggestionsSnapshot.data.isEmpty) {
                    return SizedBox();
                  }
                  final suggestions = suggestionsSnapshot.data;
                  return StreamBuilder<double>(
                      stream: globalValues.appNavigationBloc.pageValue,
                      builder: (context, pageValueSnapshot) {
                        // print("Station Select Page: " +
                        //     (pageValueSnapshot.data).toString());

                        final pageValue = pageValueSnapshot.hasData
                            ? pageValueSnapshot.data
                            : oldPageValue;
                        oldPageValue = pageValue;
                        return SingleChildScrollView(
                          padding: EdgeInsets.only(
                              top: size.height * (1 - pageValue),
                              bottom: Helper.height(108, size) +
                                  (keyboardVisible
                                      ? overlap
                                      : MediaQuery.of(context)
                                          .viewPadding
                                          .bottom)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: suggestions
                                .map((station) => GestureDetector(
                                      behavior: HitTestBehavior.translucent,
                                      onTap: () {
                                        suggestionsBloc.updateStation(station);
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: size.height /
                                                2 *
                                                (1 - pageValue)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: StationCardForSelector(
                                            station: station,
                                          ),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        );
                      });
                }),
          ),
        ),
      ],
    );
  }
}
