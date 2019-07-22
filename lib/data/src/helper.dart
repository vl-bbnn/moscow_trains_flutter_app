import 'package:flutter/material.dart';
import 'package:trains/data/classes/suggestion.dart';
import 'package:trains/data/classes/train.dart';

class Helper {
  static List<String> minutesToText(int minutesTotal) {
    var hoursText = "", minutesText = "", fullText = "";
    final hours = (minutesTotal / 60).floor();
    final minutes = minutesTotal - hours * 60;
    if (hours > 0) {
      final end = hours % 10;
      if (hours > 4 && hours < 21 || end > 4 || end == 0)
        hoursText = "часов";
      else if (end > 1 && end < 5)
        hoursText = "часа";
      else if (end == 1) hoursText = "час";
      fullText += hours.toString() + " " + hoursText;
      if (minutes > 0) fullText += " ";
    }
    if (minutes > 0) {
      final end = minutes % 10;
      if (minutes > 4 && minutes < 21 || end > 4 || end == 0)
        minutesText = "минут";
      else if (end > 1 && end < 5)
        minutesText = "минуты";
      else if (end == 1) minutesText = "минуту";
      fullText += minutes.toString() + " " + minutesText;
    }
    return [
      hours.toString(),
      hoursText,
      minutes.toString(),
      minutesText,
      fullText
    ];
  }

  static shortMinutesText(int minutesTotal) {
    final timeText = minutesToText(minutesTotal);
    final nextText = minutesToText(minutesTotal + 60);
    final hours = timeText.elementAt(0);
    final hoursText = timeText.elementAt(1);
    final hoursNext = nextText.elementAt(0);
    final hoursNextText = nextText.elementAt(1);
    final minutes = minutesTotal % 60;
    var text = "$hours $hoursText";
    final next = "$hoursNext $hoursNextText";
    var textAndAHalf = "$hours.5 $hoursText";
    if (int.parse(hours) == 1) textAndAHalf += "а";
    if (minutes <= 20)
      text = "~ $text";
    else if (minutes <= 45)
      text = "~ $textAndAHalf";
    else
      text = "~ $next";
    return text;
  }

  static Map<String, String> shortMetersText(int metersTotal) {
    final kilometers = (metersTotal / 100).round() / 10;
    if (kilometers > 1)
      return {
        "full": "$kilometers км",
        "num": kilometers.toString(),
        "unit": "км"
      };
    final meters = (metersTotal / 50).round() * 50;
    return {"full": "$meters м", "num": meters.toString(), "unit": "м"};
  }

  static List<String> stopsText(int stops) {
    var text = "";
    if (stops == 1)
      return ["следующая"];
    else if (stops < 1)
      return ["уже прибыл"];
    else {
      final end = stops % 10;
      if (stops > 4 && stops < 21 || end > 4 || end == 0)
        text = "остановок";
      else if (end > 1 && end < 5)
        text = "остановки";
      else if (end == 1) text = "остановка";
    }
    return [stops.toString() + " " + text, text];
  }

  static IconData suggestionIconData(Label label) {
    switch (label) {
      case Label.closest:
        return Icons.location_on;
      case Label.home:
        return Icons.home;
      case Label.work:
        return Icons.work;
      case Label.custom:
        return Icons.edit;
      default:
        return Icons.close;
    }
  }

  static String trainTypeName(TrainType type) {
    switch (type) {
      case TrainType.last:
        return "Экспресс";
      case TrainType.lastm:
        return "Комфорт";
      case TrainType.suburban:
        return "Стандарт";
      default:
        return "Тип не задан";
    }
  }
}
