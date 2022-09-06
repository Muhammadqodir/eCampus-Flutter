import 'dart:developer';
import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:json_annotation/json_annotation.dart';

part 'subject_models.g.dart';

@JsonSerializable()
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

  factory AcademicYearsModel.fromJson(Map<String, dynamic> json) =>
      _$AcademicYearsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AcademicYearsModelToJson(this);
}

@JsonSerializable()
class TermModel {
  bool isCurrent = false;
  String termTypeName = "";
  String name = "";
  int parentId = -1;
  int id = -1;

  TermModel.buildDefault();

  TermModel(
      this.isCurrent, this.termTypeName, this.name, this.parentId, this.id);

  factory TermModel.fromJson(Map<String, dynamic> json) =>
      _$TermModelFromJson(json);

  Map<String, dynamic> toJson() => _$TermModelToJson(this);
}

@JsonSerializable()
class SubjectModel {
  String name = "";
  String teacherName = "";
  int teacherId = -1;
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
    this.teacherName = "",
    this.teacherId = -1,
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

  factory SubjectModel.fromJson(Map<String, dynamic> json) =>
      _$SubjectModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectModelToJson(this);

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
                    // hasLectures || hasInstruction || hasUMK
                    false
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
                    teacherName != ""
                        ? Row(
                            children: [
                              const Icon(
                                EcampusIcons.icons8_teacher,
                                size: 18,
                              ),
                              const SizedBox(
                                width: 4,
                              ),
                              Text(
                                teacherName,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          )
                        : const SizedBox(),
                    // teacherName != ""
                    //     ? Container(
                    //         decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(12.0),
                    //           color: getSubTypeColor(),
                    //         ),
                    //         child: Padding(
                    //           padding: EdgeInsets.all(4),
                    //           child: Text(
                    //             teacherName,
                    //             style:
                    //                 Theme.of(context).textTheme.headlineMedium,
                    //           ),
                    //         ),
                    //       )
                    //     : SizedBox(),
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

@JsonSerializable()
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

  factory LessonTypesModel.fromJson(Map<String, dynamic> json) =>
      _$LessonTypesModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonTypesModelToJson(this);
}

@JsonSerializable()
class LessonItemModel {
  int id = 0, loadId = 0, attendance = 0, kodPr = 0;
  double gainedScore = 0, grade = 0, lostScore = 0;
  String subject = "", name = "", room = "", date = "", gradeText = "отлично";
  bool isCheckpoint = false, hasFile = false;

  LessonItemModel.buildDefault();

  factory LessonItemModel.fromJson(Map<String, dynamic> json) =>
      _$LessonItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$LessonItemModelToJson(this);

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
    if (gradeText == "отлично" || gradeText == "зачтено") {
      return CustomColors.perfect;
    } else if (gradeText == "хорошо") {
      return CustomColors.good;
    } else if (gradeText == "удовлетворительно") {
      return CustomColors.satisfactorily;
    } else {
      return CustomColors.unsatisfactorily;
    }
  }

  String getDate() {
    log(date);
    if (date != "") {
      return DateFormat('dd.MM.yyyy').format(DateTime.parse(date));
    } else {
      return "";
    }
  }

  bool isKtOpen() {
    if (date != "") {
      return DateTime.parse(date) == DateTime.now() ||
          DateTime.parse(date).isBefore(DateTime.now());
    } else {
      return false;
    }
  }

  Widget getAttendanceView(BuildContext context) {
    if (attendance != 1) {
      return Container(
        decoration: BoxDecoration(
          color: attendance == 2 ? CustomColors.warning : CustomColors.error,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        child: Row(
          children: [
            const Icon(
              EcampusIcons.icons8_user_not_found,
              size: 21,
              color: Colors.white,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              attendance == 2 ? "У" : "Н",
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Widget getScoreView(BuildContext context) {
    if (gainedScore > 0) {
      return Container(
        margin: const EdgeInsets.only(top: 3),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: getScoreBgColor(),
        ),
        child: Padding(
          padding: const EdgeInsets.all(3),
          child: Row(
            children: [
              const Icon(
                EcampusIcons.icons8_star,
                size: 21,
                color: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                gradeText,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(
                width: 2,
              ),
              const Icon(
                EcampusIcons.icons8_up,
                size: 21,
                color: Colors.white,
              ),
              const SizedBox(
                width: 2,
              ),
              Text(
                gainedScore.toString(),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox();
    }
  }

  Color getKtColor(BuildContext context) {
    if (isKtOpen()) {
      if (gainedScore > 0) {
        return CustomColors.success;
      } else {
        return CustomColors.error;
      }
    } else {
      return Theme.of(context).textTheme.bodyMedium!.color ?? Colors.black;
    }
  }

  Widget getView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          getDate() != ""
              ? Text(
                  getDate(),
                  textAlign: TextAlign.start,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              : const SizedBox(),
          const SizedBox(
            height: 3,
          ),
          Row(
            children: [
              isCheckpoint
                  ? Row(
                      children: [
                        Icon(
                          EcampusIcons.icons8_select,
                          size: 22,
                          color: getKtColor(context),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                      ],
                    )
                  : const SizedBox(),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    subject != ""
                        ? Text(
                            subject,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          )
                        : const SizedBox(),
                    Text(
                      name,
                      style: Theme.of(context).textTheme.bodyMedium,
                      overflow: TextOverflow.fade,
                    ),
                    Row(
                      children: [
                        getScoreView(context),
                      ],
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    Row(
                      children: [
                        getAttendanceView(context),
                      ],
                    ),
                  ],
                ),
              ),
              // SizedBox(
              //   width: 60,
              //   height: 60,
              //   child: CupertinoButton(
              //     borderRadius: BorderRadius.circular(50),
              //     padding: const EdgeInsets.all(0),
              //     onPressed: () {},
              //     child: Icon(EcampusIcons.icons8_communication),
              //     color: Theme.of(context).primaryColor,
              //   ),
              // ),
            ],
          )
        ],
      ),
    );
  }
}
