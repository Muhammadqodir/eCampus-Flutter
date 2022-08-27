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
                onPressed: (){
                  setSelected(list.indexOf(e));
                },
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
                    list.indexOf(e) == selectedIndex
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
