import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:trains/ui/backpanel/search/datetimepage/datetimepage.dart';
import 'package:trains/ui/backpanel/search/historypage/historypage.dart';
import 'package:trains/ui/backpanel/search/searchmodeswitcher/searchmodeswitcher.dart';
import 'package:trains/ui/backpanel/search/stationspage/stationspage.dart';

class BackPanelSearch extends StatefulWidget {
  @override
  _BackPanelSearchState createState() => _BackPanelSearchState();
}

class _BackPanelSearchState extends State<BackPanelSearch> {
  final _currentPage = BehaviorSubject<int>();
  PageController pageController;

  @override
  void initState() {
    pageController = new PageController(initialPage: 1);
    _currentPage.sink.add(1);
    _currentPage.stream.listen((index) {
      if (index != 1) FocusScope.of(context).unfocus();
      if ((pageController.page.round() - index).abs() > 1) {
        pageController.jumpToPage(index);
      } else
        pageController.animateToPage(index,
            duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    _currentPage.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SearchModeSwitcher(
          currentPage: _currentPage,
        ),
        Expanded(
          child: PageView(
            controller: pageController,
            onPageChanged: (newPage) {
              _currentPage.sink.add(newPage);
            },
            dragStartBehavior: DragStartBehavior.start,
            children: <Widget>[
              HistoryPage(),
              StationsPage(),
              DateTimePage(),
            ],
          ),
        ),
      ],
    );
  }
}
