import 'package:flutter/material.dart';
import 'package:trains/data/blocs/frontpanelbloc.dart';
import 'package:trains/data/blocs/inheritedbloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/blocs/searchbloc.dart';
import 'package:trains/ui/res/mycolors.dart';
import 'package:trains/ui/res/stationcard.dart';

enum BackgroundState { Stations, CloseButton }

class SearchStations extends StatefulWidget {
  @override
  _SearchStationsState createState() => _SearchStationsState();
}

class _SearchStationsState extends State<SearchStations> {
  final _stationsKey = GlobalKey();
  var _state = BackgroundState.Stations;
  var _screenHeight = 0.0;

  initState() {
    InheritedBloc.frontPanelBloc.panelSlide.listen((slide) {
      if (this.mounted) if (slide < 0.5 && _state != BackgroundState.Stations) {
        setState(() {
          _state = BackgroundState.Stations;
        });
      } else if (slide >= 0.5 && _state != BackgroundState.CloseButton) {
        setState(() {
          _state = BackgroundState.CloseButton;
        });
      }
    });
    super.initState();
  }

  _switcherBody() {
    switch (_state) {
      case BackgroundState.Stations:
        return _stations();
      case BackgroundState.CloseButton:
        return _closeButton();
    }
    return Container();
  }

  _updatePanelMinHeight(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _stationsKey.currentContext.findRenderObject() as RenderBox;
      // print("Widget height: " + renderBox.size.height.toString());
      InheritedBloc.frontPanelBloc
          .updateMinHeight(_screenHeight - renderBox.size.height);
    });
  }

  _updatePanelMaxHeight(context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final renderBox =
          _stationsKey.currentContext.findRenderObject() as RenderBox;
      // print("Button height: " + renderBox.size.height.toString());
      InheritedBloc.frontPanelBloc
          .updateMaxHeight(_screenHeight - renderBox.size.height);
    });
  }

  _closeButton() {
    _updatePanelMaxHeight(context);
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        await InheritedBloc.frontPanelBloc.scrollScheduleTo(0);
        await InheritedBloc.frontPanelBloc.panelController.close();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Icon(
              Icons.close,
              color: MyColors.BLACK,
              size: 24,
            ),
            Text(
              "Закрыть".toUpperCase(),
              style: TextStyle(
                  color: MyColors.BLACK,
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w500,
                  fontSize: 18),
            ),
            SizedBox(
              width: 24,
              height: 24,
            )
          ],
        ),
      ),
    );
  }

  _stations() {
    final searchBloc = InheritedBloc.searchBloc;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 50),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          StreamBuilder<Station>(
              stream: searchBloc.fromStation,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    InheritedBloc.searchBloc.stationType.add(Input.departure);
                    InheritedBloc.frontPanelBloc.state
                        .add(FrontPanelState.StationSelect);
                  },
                  child: StationCard(
                    size: StationCardSize.big,
                    station: snapshot.data,
                  ),
                );
              }),
          SizedBox(
            height: 25,
          ),
          GestureDetector(
            child: Icon(
              Icons.arrow_downward,
              size: 24,
              color: MyColors.GREY,
            ),
            onTap: () {
              searchBloc.switchInputs();
            },
          ),
          SizedBox(
            height: 25,
          ),
          StreamBuilder<Station>(
              stream: searchBloc.toStation,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                _updatePanelMinHeight(context);
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () {
                    InheritedBloc.searchBloc.stationType.add(Input.arrival);
                    InheritedBloc.frontPanelBloc.state
                        .add(FrontPanelState.StationSelect);
                  },
                  child: StationCard(
                    size: StationCardSize.big,
                    station: snapshot.data,
                  ),
                );
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          key: _stationsKey,
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            _switcherBody(),
          ],
        ),
        Expanded(
          child: Container(),
        )
      ],
    );
  }
}
