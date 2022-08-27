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
  int selectedIndex = 0;

  void setSelected(int value) {
    setState(() => {
      selectedIndex = value,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WeekTab(
          start: DateTime.now(),
          selectedIndex: selectedIndex,
          setSelected: setSelected,
        ),
        Expanded(
          child: PageView(
              onPageChanged: (value) => {
                    setState(
                      () => {
                        selectedIndex = value,
                      },
                    )
                  },
              children: WeekTab.weekDays
                  .map((e) => Center(
                        child: Text(e),
                      ))
                  .toList()),
        ),
      ],
    );
  }
}
