import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:flutter/material.dart';

class WeekTab extends StatelessWidget {
  const WeekTab({
    Key? key,
    required this.start,
    required this.selectedIndex,
    required this.setSelected,
  }) : super(key: key);

  final DateTime start;
  final int selectedIndex;
  final Function setSelected;

  static List<String> weekDays = [
    "Пн",
    "Вт",
    "Ср",
    "Чт",
    "Пт",
    "Сб",
    "Вс",
  ];

  static Map<String, String> weekAbbrv = {
    "Пн": "Понедельник",
    "Вт": "Вторник",
    "Ср": "Среда",
    "Чт": "Четверг",
    "Пт": "Пятница",
    "Сб": "Субота",
    "Вс": "Воскресенье",
  };

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
    List<WeekDay> list = getNextWeekDays();
    return Row(
      children: list
          .map(
            (e) => Expanded(
              child: CrossListElement(
                onPressed: () {
                  setSelected(list.indexOf(e));
                },
                child: Column(
                  children: [
                    Text(
                      e.name,
                      style: list.indexOf(e) != selectedIndex
                          ? Theme.of(context).textTheme.bodySmall
                          : Theme.of(context)
                              .textTheme
                              .bodySmall!
                              .copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      e.date.day.toString(),
                      style: list.indexOf(e) != selectedIndex
                          ? Theme.of(context).textTheme.bodyMedium
                          : Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 4,
                    ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 400),
                      height: 2,
                      width: double.infinity,
                      color: list.indexOf(e) == selectedIndex
                          ? Theme.of(context).primaryColor
                          : Colors.transparent,
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
