import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/utils/system_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WeekTab extends StatelessWidget {
  const WeekTab({
    Key? key,
    required this.start,
    required this.selected_date,
  }) : super(key: key);

  final DateTime start;
  final DateTime selected_date;

  static List<String> weekDays = [
    "Пн",
    "Вт",
    "Ср",
    "Чт",
    "Пт",
    "Сб",
    "Вс",
  ];

  List<WeekDay> getNextWeekDays() {
    List<WeekDay> list = [];
    DateTime day = start;
    for (var i = 0; i < 7; i++) {
      list.add(WeekDay(weekDays[i], day));
      day = day.add(const Duration(days: 1));
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: getNextWeekDays()
          .map(
            (e) => Expanded(
              child: CrossListElement(
                onPressed: () {},
                child: Column(
                  children: [
                    Text(
                      e.name,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    Text(
                      e.date.day.toString(),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    e.date.day == selected_date.day
                        ? Container(
                            height: 2,
                            width: double.infinity,
                            color: Theme.of(context).primaryColor,
                          )
                        : const SizedBox(
                            height: 2,
                            width: double.infinity,
                          )
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class WeekDay {
  DateTime date = DateTime.now();
  String name = "Пн";

  WeekDay(this.name, this.date);
}
