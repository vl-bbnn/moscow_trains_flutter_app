import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:trains/data/blocs/inputtypebloc.dart';
import 'package:trains/data/classes/station.dart';
import 'package:trains/data/classes/train.dart';
import 'package:http/http.dart' as http;

class Request {
  static Future<List<Train>> search(Station fromStation, Station toStation,
      DateTime dateTime, Input reqType) async {
    final list = List<Train>();
    if (fromStation != null &&
        toStation != null &&
        dateTime != null &&
        reqType != null) {
      var _url =
          'https://us-central1-trains-3a75a.cloudfunctions.net/get_trains?to=${toStation.code}&from=${fromStation.code}';
      if (dateTime != null)
        _url +=
            "&dateTime=${DateFormat('yyyy-MM-ddTHH:mm').format(dateTime.toLocal())}";
      if (reqType != null) {
        final type = reqType.toString().replaceAll("Input.", "");
        _url += "&type=$type";
      }
      print(_url);
      final response = await http.get(_url);

      if (response.statusCode == 200) {
        (json.decode(response.body) as List<dynamic>).forEach((jsonListItem) {
          final train = Train.fromDynamic(jsonListItem);
          train.goingFromSelected =
              train.from.toLowerCase() == fromStation.name.toLowerCase();
          train.goingToSelected =
              train.to.toLowerCase() == toStation.name.toLowerCase();
          list.add(train);
        });
      }
    }
    return list;
  }
}
