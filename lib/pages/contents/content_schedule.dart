import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/bottom_nav.dart';
import 'package:ecampus_ncfu/inc/week_tab.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ContentSchedule extends StatefulWidget {
  const ContentSchedule({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<ContentSchedule> createState() => _ContentScheduleState();
}

class _ContentScheduleState extends State<ContentSchedule> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeekTab(
          start: DateTime.now(),
          selected_date: DateTime.now().add(Duration(days: 2)),
        ),
      ],
    );
  }
}
