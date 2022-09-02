import 'dart:developer';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'teacher_model.g.dart';

@JsonSerializable()
class TeacherModel {
  int id = 0;
  String fullName = "";
  List<String> subjects = [];

  TeacherModel.buildDefault();

  TeacherModel(this.id, this.fullName, this.subjects);

  void addSubject(String subject) {
    subjects.add(subject);
  }

  factory TeacherModel.fromJson(Map<String, dynamic> json) =>
      _$TeacherModelFromJson(json);

  Map<String, dynamic> toJson() => _$TeacherModelToJson(this);

  String getSubjects(){
    String res = "";
    for(var s in subjects){
      res += "-$s\n";
    }
    return res.substring(0, res.length-1);
  }

  Widget getView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            fullName,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Text(
            getSubjects(),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: CrossButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    log("Schedule");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        EcampusIcons.icons8_schedule,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Рассписание",
                        style: Theme.of(context).textTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                child: CrossButton(
                  backgroundColor: Theme.of(context).primaryColor,
                  onPressed: () {
                    log("Info");
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        EcampusIcons.icons8_info,
                        size: 24,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        "Информация",
                        style: Theme.of(context).textTheme.headlineMedium,
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
