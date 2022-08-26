import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:flutter/material.dart';

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
}

class NotificationsResponse extends Response {
  List<NotificationModel>? unread = [];
  List<NotificationModel>? read = [];

  NotificationsResponse(bool isSuccess, String error, {this.unread, this.read})
      : super(isSuccess, error);
}

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

  int getCurrentCourse() {
    for (var i = 0; i < models!.length; i++) {
      if (models![i].isCurrent) {
        return i;
      }
    }
    return 0;
  }

  int getCurrentTerm(){
    for (var i = 0; i < models!.length; i++) {
      for(var j = 0; j < models![i].termModels.length; j++){
        TermModel termModel = models![i].termModels[j];
        if (termModel.isCurrent) {
          return termModel.id;
        }
      }
    }
    return 0;
  }
}

class SubjectsResponse extends Response {
  List fileAbleActivities = [];
  List sciFiles = [];
  List<SubjectModel> models = [];

  SubjectsResponse(
    bool isSuccess,
    String error, {
    this.fileAbleActivities = const [],
    this.sciFiles = const [],
    this.models = const [],
  }) : super(isSuccess, error);

  SubjectsResponse.buildDefault() : super(false, "undefined");
}
