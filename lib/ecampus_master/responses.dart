import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/models/schedule_models.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:ecampus_ncfu/models/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
part 'responses.g.dart';

class Response {
  bool isSuccess = false;
  String error = "";
  dynamic data;

  Response(this.isSuccess, this.error);
}

class AuthenticateResponse extends Response {
  String userName = "";
  String cookie = "";

  AuthenticateResponse(bool isSuccess, String error,
      [this.userName = "undefined", this.cookie = "undefined"])
      : super(isSuccess, error);
}

@JsonSerializable()
class RatingResponse extends Response {
  double averageRating = -1;
  int groupRating = -1;
  int instituteRating = -1;
  int studentsNumberInGroup = -1;
  int studentsNumberInInstitute = -1;
  List<RatingModel> items = [];
  RatingResponse(
    bool isSuccess,
    String error, [
    this.averageRating = -1,
    this.groupRating = -1,
    this.instituteRating = -1,
    this.studentsNumberInGroup = -1,
    this.studentsNumberInInstitute = -1,
    this.items = const [],
  ]) : super(isSuccess, error);

  factory RatingResponse.fromJson(Map<String, dynamic> json) => _$RatingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RatingResponseToJson(this);
}

@JsonSerializable()
class NotificationsResponse extends Response {
  List<NotificationModel>? unread = [];
  List<NotificationModel>? read = [];

  NotificationsResponse(bool isSuccess, String error, {this.unread, this.read})
      : super(isSuccess, error);

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) => _$NotificationsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationsResponseToJson(this);
}

@JsonSerializable()
class AcademicYearsResponse extends Response {
  List<AcademicYearsModel>? models = [];
  int? kodCart = -1;
  int? portionSize = -1;
  int? studentId = -1;
  SubjectsResponse? currentSubjects = SubjectsResponse.buildDefault();

  AcademicYearsResponse(bool isSuccess, String error,
      {this.models,
      this.kodCart,
      this.portionSize,
      this.studentId,
      this.currentSubjects})
      : super(isSuccess, error);

  factory AcademicYearsResponse.fromJson(Map<String, dynamic> json) => _$AcademicYearsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AcademicYearsResponseToJson(this);

  int getCurrentCourse() {
    for (var i = 0; i < models!.length; i++) {
      if (models![i].isCurrent) {
        return i;
      }
    }
    return 0;
  }

  int getCurrentTerm() {
    for (var i = 0; i < models!.length; i++) {
      for (var j = 0; j < models![i].termModels.length; j++) {
        TermModel termModel = models![i].termModels[j];
        if (termModel.isCurrent) {
          return termModel.id;
        }
      }
    }
    return 0;
  }
}

@JsonSerializable()
class SubjectsResponse extends Response {
  List fileAbleActivities = [];
  List sciFiles = [];
  List<SubjectModel> models = [];

  factory SubjectsResponse.fromJson(Map<String, dynamic> json) => _$SubjectsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SubjectsResponseToJson(this);
  SubjectsResponse(
    bool isSuccess,
    String error, {
    this.fileAbleActivities = const [],
    this.sciFiles = const [],
    this.models = const [],
  }) : super(isSuccess, error);

  SubjectsResponse.buildDefault() : super(false, "undefined");
}

@JsonSerializable()
class LessonItemsResponse extends Response {
  List<LessonItemModel> models = [];

  LessonItemsResponse(bool isSuccess, String error, {this.models = const []}) : super(isSuccess, error);


  factory LessonItemsResponse.fromJson(Map<String, dynamic> json) => _$LessonItemsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LessonItemsResponseToJson(this);

}

@JsonSerializable()
class ScheduleWeeksResponse extends Response {
  List<ScheduleWeeksModel> weeks;
  int id = 0, type = 0, currentWeek = 0;

  ScheduleWeeksResponse(
    bool isSuccess,
    String error, {
    this.id = 0,
    this.type = 0,
    this.currentWeek = 0,
    this.weeks = const [],
  }) : super(isSuccess, error);

  factory ScheduleWeeksResponse.fromJson(Map<String, dynamic> json) => _$ScheduleWeeksResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleWeeksResponseToJson(this);
}

@JsonSerializable()
class ScheduleResponse extends Response {
  List<ScheduleModel> scheduleModels = [];

  ScheduleResponse(bool isSuccess, String error,
      {this.scheduleModels = const []})
      : super(isSuccess, error);
  
  factory ScheduleResponse.fromJson(Map<String, dynamic> json) => _$ScheduleResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ScheduleResponseToJson(this);
}

@JsonSerializable()
class MyTeachersResponse extends Response {
  List<TeacherModel> teachers = [];

  MyTeachersResponse(bool isSuccess, String error,
      {this.teachers = const []})
      : super(isSuccess, error);
  
  factory MyTeachersResponse.fromJson(Map<String, dynamic> json) => _$MyTeachersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MyTeachersResponseToJson(this);
}
