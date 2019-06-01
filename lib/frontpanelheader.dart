import 'package:flutter/material.dart';
import 'package:trains/data/Inheritedbloc.dart';
import 'package:trains/ui/suggestions.dart';
import 'package:trains/ui/textformfield.dart';
import 'package:trains/data/bloc.dart';

class FrontPanelTitle extends StatefulWidget {
  FrontPanelTitle(this.trainsBloc);

  final TrainsBloc trainsBloc;

  @override
  FrontPanelTitleState createState() {
    return new FrontPanelTitleState();
  }
}

class FrontPanelTitleState extends State<FrontPanelTitle> {
  TextEditingController ctrlFrom;
  TextEditingController ctrlTo;
  FocusNode focusOnFrom;
  FocusNode focusOnTo;
  bool panelOpen;
  bool isArrival;

  void _updateFrom() => widget.trainsBloc.from.add(ctrlFrom.value.text);

  void _updateTo() => widget.trainsBloc.to.add(ctrlTo.value.text);

  void _focusFrom() {
    if (focusOnTo.hasFocus == false && ctrlFrom.value.text.isEmpty)
      FocusScope.of(context).requestFocus(focusOnFrom);
  }

  void _focusTo() {
    if (focusOnFrom.hasFocus == false && ctrlTo.value.text.isEmpty)
      FocusScope.of(context).requestFocus(focusOnTo);
  }

  @override
  void initState() {
    isArrival = false;
    ctrlFrom = TextEditingController();
    ctrlFrom.addListener(() => _updateFrom());
    ctrlTo = TextEditingController();
    ctrlTo.addListener(() => _updateTo());
    focusOnFrom = FocusNode();
    focusOnFrom.addListener(() => _focusTo());
    focusOnTo = FocusNode();
//    focusOnTo.addListener(() => _focusFrom());
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  //  void _scrollToStart(AppModel model) {
//    int _indexInView = model.startIndex <= 2 ? model.startIndex : 2;
//    double _scrollToHorizontal, _scrollToVertical = 0.0;
//    if (_indexInView > 0) {
//      _scrollToHorizontal =
//          model.cardWidth * (_indexInView) + 8 * (2 * _indexInView);
//      _scrollToVertical =
//          model.cardListHeight * (_indexInView) + 8 * (2 * _indexInView);
//    }
//    model.isList
//        ? model.scrollVerticalController.animateTo(_scrollToVertical,
//            duration: const Duration(milliseconds: 300), curve: Curves.easeOut)
//        : model.scrollHorizontalController.animateTo(_scrollToHorizontal,
//            duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
//  }

  bool _inFocus(FocusNode node, TextEditingController ctrl) {
    return (node != null && ctrl.value.text.isNotEmpty && node.hasFocus);
  }

  Widget _controls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              GestureDetector(
                onTap: () => _arrivalSwitch(),
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 0.0,
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Icon(!isArrival
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Text(
                            !isArrival ? 'Отпр.' : 'Приб.',
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () async {
                  var _now = DateTime.now();
                  var _firstDate = DateTime(_now.year, _now.month, 1);
                  var _lastDate = DateTime(_now.year, _now.month + 2, 0);
                  await showDatePicker(
                      context: context,
                      initialDate: _now,
                      initialDatePickerMode: DatePickerMode.day,
                      firstDate: _firstDate,
                      lastDate: _lastDate);
                },
                child: Material(
                  borderRadius: BorderRadius.circular(10.0),
                  elevation: 0.0,
                  color: Colors.grey[200],
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                          child: Icon(Icons.access_time),
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 4.0),
                            child: StreamBuilder<DateTime>(
                              stream: widget.trainsBloc.selectedDateStream,
                              builder: (context, snapshot) {
                                var now = DateTime.now();
                                var text = '';
                                if (snapshot.data == null ||
                                    snapshot.data.day == now.day)
                                  text = 'Сейчас';
                                else if (snapshot.data.day != now.day)
                                  text += snapshot.data.day.toString() +
                                      ' ' +
                                      widget.trainsBloc.monthsNames
                                          .elementAt(snapshot.data.month - 1)
                                          .substring(0, 3) +
                                      ', ' +
                                      widget.trainsBloc
                                          .formatTime(snapshot.data);
                                return Text(
                                  text,
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.w500),
                                );
                              },
                            )),
                      ],
                    ),
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.circular(10.0),
                elevation: 0.0,
                color: Colors.grey[200],
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(Icons.train),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Text(
                          'Все',
                          style: TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 16.0),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  _arrivalSwitch() {
    setState(() {
      isArrival = !isArrival;
    });
    widget.trainsBloc.isArrival.add(isArrival);
  }

  @override
  Widget build(BuildContext context) {
    return InheritedBloc(
      trainsBloc: widget.trainsBloc,
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: InputForm(InputType.from, ctrlFrom, focusOnFrom)),
                Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: InputForm(InputType.to, ctrlTo, focusOnTo)),
              ],
            ),
            _inFocus(focusOnTo, ctrlTo)
                ? Suggestions(InputType.to)
                : Container(),
            _controls(context),
          ],
        ),
      ),
    );
  }
}
