import 'package:curb_companion/utils/helpers/datetime.dart';
import 'package:flutter/material.dart';
import 'package:rrule/rrule.dart';

List<String> days = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturday",
  "Sunday",
];

int weekDayIndex = DateTime.now().weekday;

class BuildEachDay extends StatefulWidget {
  final List<dynamic> schedule;
  const BuildEachDay({super.key, required this.schedule});

  @override
  State<BuildEachDay> createState() => _BuildEachDayState();
}

class _BuildEachDayState extends State<BuildEachDay> {
  @override
  Widget build(BuildContext context) {
    RecurrenceRule? rrule;
    // TODO: ?
    // ignore: unused_local_variable
    String? dtstart;
    Map<String, List<DateTime>> weeklySchedule = {};
    List<Widget> scheduleWidget = [];

    for (int j = 0; j < widget.schedule.length; j++) {
      for (int i = 0; i < widget.schedule[j]["recurrence"].length; i++) {
        if (widget.schedule[j]["recurrence"][i].startsWith("RRULE")) {
          rrule =
              RecurrenceRule.fromString(widget.schedule[j]["recurrence"][i]);
        } else if (widget.schedule[j]["recurrence"][i].startsWith("DTSTART")) {
          dtstart = widget.schedule[j]["recurrence"][i];
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

        DateTime startDateTime =
            DateTime.parse(widget.schedule[j]["start"]!.toString()).toLocal();
        DateTime endDateTime =
            DateTime.parse(widget.schedule[j]["end"]!.toString()).toLocal();

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
        for (String day in sortedByValueMap.keys) {
          bool isToday = day == days[weekDayIndex - 1];

          scheduleWidget.add(Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Material(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    child: Text(
                      day,
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        fontSize: isToday ? 16 : 14,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                  SizedBox(
                    child: Text(
                      "${timeString(startDateTime)} - ${timeString(endDateTime)}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: isToday ? 16 : 14,
                        fontWeight:
                            isToday ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ));
        }
        weeklySchedule = {};
      }
    }
    return SingleChildScrollView(
      child: Column(
        children: scheduleWidget,
      ),
    );
  }
}
