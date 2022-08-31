// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleModel _$ScheduleModelFromJson(Map<String, dynamic> json) =>
    ScheduleModel(
      weekDay: json['weekDay'] as String,
      date: DateTime.parse(json['date'] as String),
      lessons: (json['lessons'] as List<dynamic>)
          .map((e) => ScheduleLessonsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ScheduleModelToJson(ScheduleModel instance) =>
    <String, dynamic>{
      'weekDay': instance.weekDay,
      'date': instance.date.toIso8601String(),
      'lessons': instance.lessons,
    };

ScheduleWeeksModel _$ScheduleWeeksModelFromJson(Map<String, dynamic> json) =>
    ScheduleWeeksModel(
      weekType: json['weekType'] as String,
      dateBegin: json['dateBegin'] as String,
      dateEnd: json['dateEnd'] as String,
      number: json['number'] as String,
    );

Map<String, dynamic> _$ScheduleWeeksModelToJson(ScheduleWeeksModel instance) =>
    <String, dynamic>{
      'weekType': instance.weekType,
      'dateBegin': instance.dateBegin,
      'dateEnd': instance.dateEnd,
      'number': instance.number,
    };

ScheduleLessonsModel _$ScheduleLessonsModelFromJson(
        Map<String, dynamic> json) =>
    ScheduleLessonsModel(
      subName: json['subName'] as String,
      room: json['room'] as String,
      timeStart: DateTime.parse(json['timeStart'] as String),
      timeEnd: DateTime.parse(json['timeEnd'] as String),
      teacher: json['teacher'] as String,
      lessonType: json['lessonType'] as String,
      group: json['group'] as String,
      para: json['para'] as int,
      teacherId: json['teacherId'] as int,
      roomId: json['roomId'] as int,
      current: json['current'] as bool,
    );

Map<String, dynamic> _$ScheduleLessonsModelToJson(
        ScheduleLessonsModel instance) =>
    <String, dynamic>{
      'subName': instance.subName,
      'room': instance.room,
      'teacher': instance.teacher,
      'lessonType': instance.lessonType,
      'group': instance.group,
      'timeStart': instance.timeStart.toIso8601String(),
      'timeEnd': instance.timeEnd.toIso8601String(),
      'para': instance.para,
      'teacherId': instance.teacherId,
      'roomId': instance.roomId,
      'current': instance.current,
    };
