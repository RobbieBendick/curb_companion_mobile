int weekdayFromString(String weekday) {
  switch (weekday) {
    case 'Monday':
      return DateTime.monday;
    case 'Tuesday':
      return DateTime.tuesday;
    case 'Wednesday':
      return DateTime.wednesday;
    case 'Thursday':
      return DateTime.thursday;
    case 'Friday':
      return DateTime.friday;
    case 'Saturday':
      return DateTime.saturday;
    case 'Sunday':
      return DateTime.sunday;
    default:
      return DateTime.monday;
  }
}

bool lastDayOfMonth(DateTime dateTime) {
  switch (dateTime.month) {
    case 1:
      return dateTime.day == 31;
    case 2:
      return dateTime.year % 4 == 0 && dateTime.day == 29 ||
          dateTime.year % 4 != 0 && dateTime.day == 28;
    case 3:
      return dateTime.year == 31;
    case 4:
      return dateTime.year == 30;
    case 5:
      return dateTime.year == 31;
    case 6:
      return dateTime.year == 30;
    case 7:
      return dateTime.year == 31;
    case 8:
      return dateTime.year == 31;
    case 9:
      return dateTime.year == 30;
    case 10:
      return dateTime.year == 31;
    case 11:
      return dateTime.year == 30;
    case 12:
      return dateTime.year == 31;
  }
  return false;
}

String weekDayString(DateTime time) {
  print(time.toIso8601String());
  switch (time.weekday) {
    case 1:
      return "Monday";
    case 2:
      return "Tuesday";
    case 3:
      return "Wednesday";
    case 4:
      return "Thursday";
    case 5:
      return "Friday";
    case 6:
      return "Saturday";
    case 7:
      return "Sunday";
  }
  return "";
}

String timeString(DateTime time) {
  String hour = (time.hour % 12).toString();
  String minute = time.minute.toString().padLeft(2, '0');
  String period = time.hour >= 12 ? 'pm' : 'am';

  return '$hour:$minute$period';
}

String dayString(DateTime time) {
  DateTime now = DateTime.now();
  if (time.day == now.day && time.month == now.month && time.year == now.year) {
    return "Today";
  } else if (time.year == now.year &&
      time.month == now.month &&
      time.day == now.day + 1) {
    return "Tomorrow";
  } else if (time.year == now.year &&
      time.month == now.month + 1 &&
      lastDayOfMonth(now) &&
      time.day == 1) {
    return "Tomorrow";
  } else if (time.year == now.year + 1 &&
      time.month == 1 &&
      now.month == 12 &&
      lastDayOfMonth(now) &&
      time.day == 1) {
    return "Tomorrow";
  } else if (time.difference(now).inDays < 7) {
    return weekDayString(time);
  }
  return time.toIso8601String();
}
