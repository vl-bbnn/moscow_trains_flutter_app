import 'package:intl/intl.dart';
import 'package:trains/data/classes/train.dart';

class Helper {
  static Map<String, String> minutesToText(int minutesTotal) {
    if (minutesTotal == 0)
      return {
        "isBefore": "false",
        "hours": "0",
        "hoursText": "",
        "minutes": "0",
        "minutesText": "",
        "shortText": "сейчас",
        "fullText": "сейчас"
      };
    var hoursText = "",
        minutesText = "",
        fullText = "",
        shortText = "",
        isBefore = minutesTotal < 0;
    final correctedMinutes = isBefore ? -minutesTotal : minutesTotal;
    final hours = (correctedMinutes / 60).floor();
    final minutes = correctedMinutes - hours * 60;
    if (hours > 0) {
      final end = hours % 10;
      if (hours > 4 && hours < 21 || end > 4 || end == 0)
        hoursText = "часов";
      else if (end > 1 && end < 5)
        hoursText = "часа";
      else if (end == 1) hoursText = "час";
      fullText = hours.toString() + " " + hoursText;
      shortText = hours.toString() + " ч";
      if (minutes > 0) {
        fullText += " ";
        shortText += " ";
      }
    }
    if (minutes > 0) {
      final end = minutes % 10;
      if (minutes > 4 && minutes < 21 || end > 4 || end == 0)
        minutesText = "минут";
      else if (end > 1 && end < 5)
        minutesText = "минуты";
      else if (end == 1) minutesText = "минуту";
      fullText += minutes.toString() + " " + minutesText;
      shortText += minutes.toString() + " мин";
    }
    return {
      "isBefore": isBefore.toString(),
      "hours": hours.toString(),
      "hoursText": hoursText,
      "minutes": minutes.toString(),
      "minutesText": minutesText,
      "shortText": shortText,
      "fullText": fullText
    };
  }

  static Map<String, String> weekday(int weekday) {
    switch (weekday) {
      case 1:
        return {"short": "ПН", "full": "Понедельник"};
      case 2:
        return {"short": "ВТ", "full": "Вторник"};
      case 3:
        return {"short": "СР", "full": "Среда"};
      case 4:
        return {"short": "ЧТ", "full": "Четверг"};
      case 5:
        return {"short": "ПТ", "full": "Пятница"};
      case 6:
        return {"short": "СБ", "full": "Суббота"};
      case 7:
        return {"short": "ВС", "full": "Воскресенье"};
    }
    return {"short": "Нет", "full": "Нет"};
  }

  static month(int number) {
    switch (number) {
      case 1:
        return {"regular": "январь", "short": "янв", "cased": "января"};
      case 2:
        return {"regular": "февраль", "short": "фев", "cased": "февраля"};
      case 3:
        return {"regular": "март", "short": "мар", "cased": "марта"};
      case 4:
        return {"regular": "апрель", "short": "апр", "cased": "апреля"};
      case 5:
        return {"regular": "май", "short": "май", "cased": "мая"};
      case 6:
        return {"regular": "июнь", "short": "июн", "cased": "июня"};
      case 7:
        return {"regular": "июль", "short": "июл", "cased": "июля"};
      case 8:
        return {"regular": "август", "short": "авг", "cased": "августа"};
      case 9:
        return {"regular": "сентябрь", "short": "сен", "cased": "сентября"};
      case 10:
        return {"regular": "октябрь", "short": "окт", "cased": "октября"};
      case 11:
        return {"regular": "ноябрь", "short": "ноя", "cased": "ноября"};
      case 12:
        return {"regular": "декабрь", "short": "дек", "cased": "декабря"};
    }
    return {"regular": "ошибка", "short": "оши", "cased": "ошибка"};
  }

  static isToday(DateTime date) {
    final now = DateTime.now();
    final tommorow = DateTime(now.year, now.month, now.day + 1);
    return date.isBefore(tommorow);
  }

  static formatDate(DateTime dateTime) {
    final now = DateTime.now();

    final today = isToday(dateTime);
    final tommorow = dateTime.difference(now).inDays.abs() < 2 &&
        dateTime.day == now.day + 1;
    var dateText = "top";
    if (today)
      dateText = "сегодня";
    else if (tommorow)
      dateText = "завтра";
    else {
      final monthText = month(dateTime.month)["cased"];
      dateText = dateTime.day.toString() + " " + monthText;
    }

    final timeText = DateFormat("Hm").format(dateTime);

    return {
      "dateText": dateText,
      "timeText": timeText,
      "fullText": dateText + "\n" + timeText
    };
  }

  // static shortMinutesText(int minutesTotal) {
  //   final timeText = minutesToText(minutesTotal);
  //   final nextText = minutesToText(minutesTotal + 60);
  //   final hours = timeText.elementAt(0);
  //   final hoursText = timeText.elementAt(1);
  //   final hoursNext = nextText.elementAt(0);
  //   final hoursNextText = nextText.elementAt(1);
  //   final minutes = minutesTotal % 60;
  //   var text = "$hours $hoursText";
  //   final next = "$hoursNext $hoursNextText";
  //   var textAndAHalf = "$hours.5 $hoursText";
  //   if (int.parse(hours) == 1) textAndAHalf += "а";
  //   if (minutes <= 20)
  //     text = "~ $text";
  //   else if (minutes <= 45)
  //     text = "~ $textAndAHalf";
  //   else
  //     text = "~ $next";
  //   return text;
  // }

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

  static String trainTypeName(TrainClass type) {
    switch (type) {
      case TrainClass.comfort:
        return "Комфорт";
      case TrainClass.regular:
        return "Стандарт";
      case TrainClass.express:
        return "Экспресс";

      default:
        return "Тип не задан";
    }
  }

  static int timeDiffInMins(DateTime target, DateTime fact) {
    // print(DateFormat("Hm").format(target) +
    //     " - " +
    //     DateFormat("Hm").format(fact));
    return (target.difference(fact).inSeconds / 60).ceil();
  }
}
