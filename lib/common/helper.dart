enum QueryType { departure, arrival }

class Helper {
  static Map<String, String> minutesToText(int minutesTotal) {
    if (minutesTotal == null || minutesTotal == 0)
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

  static dateText(DateTime dateTime) {
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

    // final timeText = DateFormat("Hm").format(dateTime);

    return dateText;

    // return {
    //   "dateText": dateText,
    //   "timeText": timeText,
    //   "fullText": dateText + "\n" + timeText
    // };
  }

  static Map<String, String> stopsToText(int stops) {
    if (stops == null || stops == 0)
      return {
        "shortText": "Без ост",
        "fullText": "Без остановок",
        "stops": "Без",
        "stopsText": "остановок"
      };
    var fullText = "", shortText = "", stopsText = "";
    final end = stops % 10;
    if (stops > 4 && stops < 21 || end > 4 || end == 0)
      stopsText = "остановок";
    else if (end > 1 && end < 5)
      stopsText = "остановки";
    else if (end == 1) stopsText = "остановка";
    fullText = stops.toString() + " " + stopsText;
    shortText = stops.toString() + " ост";

    return {
      "shortText": shortText,
      "fullText": fullText,
      "stops": stops.toString(),
      "stopsText": stopsText,
    };
  }

  static int timeDiffInMins(DateTime target, DateTime fact) {
    return (target.difference(fact).inSeconds / 60).abs().ceil();
  }

  static height(value, size) {
    final newHeight = size.height * (value / 812);
    // print("Height: " + value.toString() + " -> " + newHeight.toString());
    return newHeight;
  }

  static width(value, size) {
    final newWidth = size.width * (value / 375);
    // print("Width: " + value.toString() + " -> " + newWidth.toString());
    return newWidth;
  }
}
