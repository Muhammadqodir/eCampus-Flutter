import 'dart:math';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
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
                    const SizedBox(
                      height: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.green,
                        border: Border.all(
                          width: 5,
                          color: Colors.green,
                        ),
                      ),
                      child: Text(
                        subType,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    CrossButton(
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
                            style: Theme.of(context).textTheme.headlineMedium,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularPercentIndicator(
                    radius: 40.0,
                    animation: true,
                    animationDuration: 400,
                    lineWidth: 5.0,
                    backgroundWidth: 3.0,
                    percent: min(currentRating / maxRating.toDouble(), 1),
                    center: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "$currentRating",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "из",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "$maxRating",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ),
                    circularStrokeCap: CircularStrokeCap.butt,
                    backgroundColor: Theme.of(context).disabledColor,
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
