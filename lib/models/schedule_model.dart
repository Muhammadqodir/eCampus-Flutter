import 'package:flutter/material.dart';

class ScheduleLessonsModel{
  String subName, room, timeStart, timeEnd, teacher, lessonType, group;
  int para, teacherId, roomId;
  bool current;

  ScheduleLessonsModel({
    required this.subName,
    required this.room,
    required this.timeStart,
    required this.timeEnd,
    required this.teacher,
    required this.lessonType,
    required this.group,
    required this.para,
    required this.teacherId,
    required this.roomId,
    required this.current
    });

  Widget getView(){
    return Text("data");
  }

}