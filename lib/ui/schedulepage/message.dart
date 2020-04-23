import 'package:flutter/material.dart';
import 'package:trains/data/blocs/searchbloc.dart';

class Message extends StatelessWidget {
  final Status status;

  Message({Key key, this.status}) : super(key: key);

  _text() {
    switch (status) {
      case Status.searching:
        return "Выполняю\nпоиск";
      case Status.found:
        return "";
      case Status.notFound:
        return "Ничего\nне найдено";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      _text().toUpperCase(),
      style: Theme.of(context).textTheme.headline1,
    );
  }
}
