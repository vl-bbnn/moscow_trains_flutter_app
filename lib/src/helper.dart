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

  static int timeDiffInMins(DateTime target, DateTime fact) {
    return (target.difference(fact).inSeconds / 60).ceil();
  }
}
