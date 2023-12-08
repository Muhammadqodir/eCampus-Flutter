import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'schedule_models.g.dart';

@JsonSerializable()
class ScheduleModel {
  String weekDay;
  DateTime date;
  List<ScheduleLessonsModel> lessons;

  ScheduleModel({
    required this.weekDay,
    required this.date,
    required this.lessons,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleModelToJson(this);
}

@JsonSerializable()
class ScheduleWeeksModel {
  String weekType, dateBegin, dateEnd, number;

  ScheduleWeeksModel(
      {required this.weekType,
      required this.dateBegin,
      required this.dateEnd,
      required this.number});

  factory ScheduleWeeksModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleWeeksModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleWeeksModelToJson(this);

  DateTime getDateBegin() {
    return DateTime.parse(dateBegin);
  }

  DateTime getDateEnd() {
    return DateTime.parse(dateEnd);
  }

  String getStrDateBegin() {
    return DateFormat('MM.dd').format(getDateBegin());
  }

  String getStrDateEnd() {
    return DateFormat('MM.dd').format(getDateEnd());
  }
}

@JsonSerializable()
class ScheduleLessonsModel {
  String subName, room, teacher, lessonType, group;
  DateTime timeStart, timeEnd;
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

  factory ScheduleLessonsModel.fromJson(Map<String, dynamic> json) =>
      _$ScheduleLessonsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleLessonsModelToJson(this);

  String getTimeStart() {
    return "${timeStart.hour}:${timeStart.minute == 0 ? "00" : timeStart.minute}";
  }

  String getTimeEnd() {
    return "${timeEnd.hour}:${timeEnd.minute == 0 ? "00" : timeEnd.minute}";
  }

  Widget getView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
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
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    lessonType.replaceAll("  ", ""),
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    "${getTimeStart()}-${getTimeEnd()}",
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
            teacher.replaceAll("  ", " "),
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
                textAlign: TextAlign.end,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
