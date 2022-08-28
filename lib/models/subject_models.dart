import 'dart:math';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class AcademicYearsModel {
  String kursTypeName = "";
  String name = "";
  int id = -1;
  int parentId = -1;
  bool isCurrent = false;
  List<TermModel> termModels = [];

  AcademicYearsModel(this.kursTypeName, this.name, this.id, this.parentId,
      this.isCurrent, this.termModels);

  AcademicYearsModel.buildDefault();
}

class TermModel {
  bool isCurrent = false;
  String termTypeName = "";
  String name = "";
  int parentId = -1;
  int id = -1;

  TermModel.buildDefault();

  TermModel(
      this.isCurrent, this.termTypeName, this.name, this.parentId, this.id);
}

class SubjectModel {
  String name = "";
  String termsForAtt = "";
  String subType = "";
  int parentId = -1;
  int id = -1;
  double currentRating = 0;
  double maxRating = 0;
  bool locked = false;
  bool isConfirmDocumentExists = false;
  bool hasLectures = false;
  bool hasInstruction = false;
  bool hasUMK = false;
  List<LessonTypesModel> lessonTypes = [];

  SubjectModel.buildDefault();

  SubjectModel({
    required this.id,
    required this.parentId,
    required this.name,
    required this.termsForAtt,
    required this.subType,
    required this.currentRating,
    required this.maxRating,
    required this.locked,
    required this.lessonTypes,
    required this.hasInstruction,
    required this.hasLectures,
    required this.hasUMK,
    required this.isConfirmDocumentExists,
  });

  Color getSubTypeColor() {
    if (subType == "Экзамен") {
      return CustomColors.error;
    } else if (subType == "Дифференцированный зачет") {
      return CustomColors.warning;
    } else {
      return CustomColors.perfect;
    }
  }

  Widget getView(BuildContext context) {
    return Column(
      children: [
        Container(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    termsForAtt != ""
                        ? Text(
                            "в аттестацию учитываются рейтинговые баллы за $termsForAtt семестры.",
                            style: Theme.of(context).textTheme.bodySmall,
                          )
                        : const SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                    subType != ""
                        ? Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: getSubTypeColor(),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: Text(
                                subType,
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ),
                          )
                        : SizedBox(),
                    const SizedBox(
                      height: 5,
                    ),
                    hasLectures || hasInstruction || hasUMK
                        ? CrossButton(
                            wight: 120,
                            height: 32,
                            padding: const EdgeInsets.all(4),
                            backgroundColor: Theme.of(context).primaryColor,
                            onPressed: () {},
                            child: Row(
                              children: [
                                Icon(
                                  EcampusIcons.icons8_download,
                                  color: Theme.of(context).canvasColor,
                                ),
                                Text(
                                  "Загрузки",
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium,
                                )
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 30.0,
                    animation: true,
                    animationDuration: 400,
                    lineWidth: 5.0,
                    backgroundWidth: 3.0,
                    percent: maxRating != 0 ? currentRating / maxRating : 0,
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$currentRating",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          "из",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        Text(
                          "$maxRating",
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    backgroundColor: Theme.of(context).dividerColor,
                    progressColor: Theme.of(context).primaryColor,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LessonTypesModel {
  String name = "";
  bool schoolType = false;
  int lessonType = 0, kodPr = 0, parentId = -1, id = -1;

  LessonTypesModel.buildDefault();

  LessonTypesModel({
    required this.id,
    required this.parentId,
    required this.kodPr,
    required this.lessonType,
    required this.name,
    required this.schoolType,
  });
}

class LessonItemModel {
  int attendance = 0,
      gainedScore = 0,
      grade = 0,
      id = 0,
      kodPr = 0,
      loadId = 0,
      lostScore = 0;
  String subject = "", name = "", room = "", date = "", gradeText = "отлично";
  bool isCheckpoint = false, hasFile = false;

  LessonItemModel.buildDefault();

  LessonItemModel(
      {required this.id,
      required this.attendance,
      required this.gainedScore,
      required this.grade,
      required this.kodPr,
      required this.loadId,
      required this.lostScore,
      required this.subject,
      required this.name,
      required this.room,
      required this.date,
      required this.gradeText,
      required this.isCheckpoint,
      required this.hasFile});

  Color getScoreBgColor() {
    if (gradeText == "отлично") {
      return CustomColors.perfect;
    } else if (gradeText == "хорошо") {
      return CustomColors.good;
    } else if (gradeText == "удовлетворительно") {
      return CustomColors.satisfactorily;
    } else {
      return CustomColors.unsatisfactorily;
    }
  }

  Widget getView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                '19.08.2001',
                style: Theme.of(context).textTheme.bodySmall,
              )
            ],
          ),
          SizedBox(
            height: 3,
          ),
          Container(
            child: Row(
              children: [
                Icon(
                  EcampusIcons.icons8_select,
                  size: 22,
                  color: Color.fromARGB(255, 10, 119, 14),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Лабораторная работа',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: getScoreBgColor(),
                      ),
                      child: Padding(
                          padding: EdgeInsets.all(3),
                          child: Row(
                            children: [
                              Icon(
                                EcampusIcons.icons8_star,
                                size: 21,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                'отлично',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Icon(
                                EcampusIcons.icons8_up,
                                size: 21,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 2,
                              ),
                              Text(
                                '20',
                                style:
                                    Theme.of(context).textTheme.headlineMedium,
                              ),
                            ],
                          )),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      child: Row(
                        children: [
                          Icon(
                            EcampusIcons.icons8_user_not_found,
                            size: 21,
                            color: Colors.white,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            'Н',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                SizedBox(
                  width: 60,
                  height: 60,
                  child: CupertinoButton(
                    borderRadius: BorderRadius.circular(50),
                    padding: const EdgeInsets.all(0),
                    onPressed: () {},
                    child: Icon(EcampusIcons.icons8_communication),
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
