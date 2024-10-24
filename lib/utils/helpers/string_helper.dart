import 'package:curb_companion/utils/helpers/datetime.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';

class StringHelper {
  String removeDecimalZero(dynamic number) {
    String numberString = number.toString();

    if (numberString.endsWith(".0")) {
      return numberString.substring(0, numberString.length - 2);
    }

    return numberString;
  }

  static String themeModeToHumanReadableString(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.system:
        return "System";
      case ThemeMode.light:
        return "Light";
      case ThemeMode.dark:
        return "Dark";
      default:
        return "System";
    }
  }

  static String openText(List<dynamic> schedule) {
    RecurrenceRule? rrule;
    // TODO: ?
    // ignore: unused_local_variable
    String? dtstart;
    // TODO: ?
    // ignore: unused_local_variable
    Map<String, List<DateTime>> weeklySchedule = {};
    // TODO: ?
    // ignore: unused_local_variable
    List<Widget> scheduleWidget = [];

    for (int j = 0; j < schedule.length; j++) {
      for (int i = 0; i < schedule[j]["recurrence"].length; i++) {
        if (schedule[j]["recurrence"][i].startsWith("RRULE")) {
          rrule = RecurrenceRule.fromString(schedule[j]["recurrence"][i]);
        } else if (schedule[j]["recurrence"][i].startsWith("DTSTART")) {
          dtstart = schedule[j]["recurrence"][i];
        }
      }

      if (rrule != null) {
        DateTime now = DateTime.now();
        DateTime start =
            DateTime.utc(now.year, now.month, now.day - 1, 0, 0, 0);
        DateTime end = DateTime.utc(now.year, now.month, now.day, 0, 0, 0)
            .add(const Duration(days: 7));

        rrule.getAllInstances(start: start, before: end).forEach((element) {
          if (element.weekday == 7) {
            weeklySchedule["Sunday"] == null
                ? weeklySchedule["Sunday"] = [element]
                : weeklySchedule["Sunday"]?.add(element);
          } else if (element.weekday == 1) {
            weeklySchedule["Monday"] == null
                ? weeklySchedule["Monday"] = [element]
                : weeklySchedule["Monday"]?.add(element);
            weeklySchedule["Monday"]?.sort((a, b) => a.compareTo(b));
          } else if (element.weekday == 2) {
            weeklySchedule["Tuesday"] == null
                ? weeklySchedule["Tuesday"] = [element]
                : weeklySchedule["Tuesday"]?.add(element);
          } else if (element.weekday == 3) {
            weeklySchedule["Wednesday"] == null
                ? weeklySchedule["Wednesday"] = [element]
                : weeklySchedule["Wednesday"]?.add(element);
          } else if (element.weekday == 4) {
            weeklySchedule["Thursday"] == null
                ? weeklySchedule["Thursday"] = [element]
                : weeklySchedule["Thursday"]?.add(element);
          } else if (element.weekday == 5) {
            weeklySchedule["Friday"] == null
                ? weeklySchedule["Friday"] = [element]
                : weeklySchedule["Friday"]?.add(element);
          } else if (element.weekday == 6) {
            weeklySchedule["Saturday"] == null
                ? weeklySchedule["Saturday"] = [element]
                : weeklySchedule["Saturday"]?.add(element);
          }
        });

        if (kDebugMode) {
          print("Tuesday: , ${weeklySchedule["Tuesday"]}");
          print("Wednesday ${weeklySchedule["Wednesday"]}");
        }

        DateTime startDateTime =
            DateTime.parse(schedule[j]["start"]!.toString()).toLocal();
        DateTime endDateTime =
            DateTime.parse(schedule[j]["end"]!.toString()).toLocal();

        Map<String, List<DateTime>> sortedByValueMap = Map.fromEntries(
          weeklySchedule.entries.toList()
            ..sort(
              (e1, e2) {
                if (weekdayFromString(e1.key) - (now.weekday % 7) <
                    weekdayFromString(e2.key) - (now.weekday % 7)) {
                  return -1;
                } else if (weekdayFromString(e1.key) - now.weekday >
                    weekdayFromString(e2.key) - (now.weekday % 7)) {
                  return 1;
                } else {
                  return 0;
                }
              },
            ),
        );

        if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
          return 'Open now | Closes at ${timeString(endDateTime)}';
        } else {
          return 'Closed | Opens at ${timeString(startDateTime)} ${dayString(startDateTime)}';
        }
      }
    }
    return 'Closed';
  }
}
