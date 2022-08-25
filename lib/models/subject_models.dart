import 'dart:math';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
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
    } else if (subType == "Дифферинцированный зачет") {
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
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: getSubTypeColor(),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(4),
                        child: Text(
                          subType,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                    ),
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
                    percent:
                        maxRating != 0 ? min(currentRating / maxRating, 0) : 0,
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
  String subject = "", name = "", room = "", date = "", gradeText = "";
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
}
