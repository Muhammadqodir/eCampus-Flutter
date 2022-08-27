import 'package:flutter/material.dart';

class ScheduleModel{
  String weekDay;
  String date;
  List<ScheduleLessonsModel> lessons;

  ScheduleModel({
    required this.weekDay,
    required this.date,
    required this.lessons,
  });

}

class ScheduleWeeksModel {
  String weekType, dateBegin, dateEnd, number;

  ScheduleWeeksModel({
    required this.weekType, 
    required this.dateBegin, 
    required this.dateEnd, 
    required this.number
  });
}

class ScheduleLessonsModel {
  String subName, room, timeStart, timeEnd, teacher, lessonType, group;
  int para, teacherId, roomId;
  bool current;

  ScheduleLessonsModel(
      {required this.subName,
      required this.room,
      required this.timeStart,
      required this.timeEnd,
      required this.teacher,
      required this.lessonType,
      required this.group,
      required this.para,
      required this.teacherId,
      required this.roomId,
      required this.current});

  Widget getView(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).primaryColor,
                  ),
                  child: Text(
                    para.toString(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  lessonType,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const Spacer(),
            Row(
              children: [
                Text(
                  "$timeStart-$timeEnd",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          subName,
          style: Theme.of(context)
              .textTheme
              .bodyMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 7,
        ),
        Text(
          teacher,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(
          height: 7,
        ),
        Row(
          children: [
            Text(
              room,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const Spacer(),
            Text(
              group,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
