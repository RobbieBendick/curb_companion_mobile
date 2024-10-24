import 'package:curb_companion/features/map/presentation/build_each_day.dart';
import 'package:flutter/material.dart';

class BuildSchedule extends StatefulWidget {
  final List<dynamic> schedule;
  const BuildSchedule({super.key, required this.schedule});

  @override
  State<BuildSchedule> createState() => _BuildScheduleState();
}

class _BuildScheduleState extends State<BuildSchedule> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.schedule.isNotEmpty
            ? BuildEachDay(schedule: widget.schedule)
            : const Center(
                child: Text("No schedule available"),
              ),
      ],
    );
  }
}
