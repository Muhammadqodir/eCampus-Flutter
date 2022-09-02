// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'responses.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RatingResponse _$RatingResponseFromJson(Map<String, dynamic> json) =>
    RatingResponse(
      json['isSuccess'] as bool,
      json['error'] as String,
      (json['averageRating'] as num?)?.toDouble() ?? -1,
      json['groupRating'] as int? ?? -1,
      json['instituteRating'] as int? ?? -1,
      json['studentsNumberInGroup'] as int? ?? -1,
      json['studentsNumberInInstitute'] as int? ?? -1,
      (json['items'] as List<dynamic>?)
              ?.map((e) => RatingModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..data = json['data'];

Map<String, dynamic> _$RatingResponseToJson(RatingResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'error': instance.error,
      'data': instance.data,
      'averageRating': instance.averageRating,
      'groupRating': instance.groupRating,
      'instituteRating': instance.instituteRating,
      'studentsNumberInGroup': instance.studentsNumberInGroup,
      'studentsNumberInInstitute': instance.studentsNumberInInstitute,
      'items': instance.items,
    };

NotificationsResponse _$NotificationsResponseFromJson(
        Map<String, dynamic> json) =>
    NotificationsResponse(
      json['isSuccess'] as bool,
      json['error'] as String,
      unread: (json['unread'] as List<dynamic>?)
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      read: (json['read'] as List<dynamic>?)
          ?.map((e) => NotificationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    )..data = json['data'];

Map<String, dynamic> _$NotificationsResponseToJson(
        NotificationsResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'error': instance.error,
      'data': instance.data,
      'unread': instance.unread,
      'read': instance.read,
    };

AcademicYearsResponse _$AcademicYearsResponseFromJson(
        Map<String, dynamic> json) =>
    AcademicYearsResponse(
      json['isSuccess'] as bool,
      json['error'] as String,
      models: (json['models'] as List<dynamic>?)
          ?.map((e) => AcademicYearsModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      kodCart: json['kodCart'] as int?,
      portionSize: json['portionSize'] as int?,
      studentId: json['studentId'] as int?,
      currentSubjects: json['currentSubjects'] == null
          ? null
          : SubjectsResponse.fromJson(
              json['currentSubjects'] as Map<String, dynamic>),
    )..data = json['data'];

Map<String, dynamic> _$AcademicYearsResponseToJson(
        AcademicYearsResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'error': instance.error,
      'data': instance.data,
      'models': instance.models,
      'kodCart': instance.kodCart,
      'portionSize': instance.portionSize,
      'studentId': instance.studentId,
      'currentSubjects': instance.currentSubjects,
    };

SubjectsResponse _$SubjectsResponseFromJson(Map<String, dynamic> json) =>
    SubjectsResponse(
      json['isSuccess'] as bool,
      json['error'] as String,
      fileAbleActivities:
          json['fileAbleActivities'] as List<dynamic>? ?? const [],
      sciFiles: json['sciFiles'] as List<dynamic>? ?? const [],
      models: (json['models'] as List<dynamic>?)
              ?.map((e) => SubjectModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..data = json['data'];

Map<String, dynamic> _$SubjectsResponseToJson(SubjectsResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'error': instance.error,
      'data': instance.data,
      'fileAbleActivities': instance.fileAbleActivities,
      'sciFiles': instance.sciFiles,
      'models': instance.models,
    };

LessonItemsResponse _$LessonItemsResponseFromJson(Map<String, dynamic> json) =>
    LessonItemsResponse(
      json['isSuccess'] as bool,
      json['error'] as String,
      models: (json['models'] as List<dynamic>?)
              ?.map((e) => LessonItemModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..data = json['data'];

Map<String, dynamic> _$LessonItemsResponseToJson(
        LessonItemsResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'error': instance.error,
      'data': instance.data,
      'models': instance.models,
    };

ScheduleWeeksResponse _$ScheduleWeeksResponseFromJson(
        Map<String, dynamic> json) =>
    ScheduleWeeksResponse(
      json['isSuccess'] as bool,
      json['error'] as String,
      id: json['id'] as int? ?? 0,
      type: json['type'] as int? ?? 0,
      currentWeek: json['currentWeek'] as int? ?? 0,
      weeks: (json['weeks'] as List<dynamic>?)
              ?.map(
                  (e) => ScheduleWeeksModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..data = json['data'];

Map<String, dynamic> _$ScheduleWeeksResponseToJson(
        ScheduleWeeksResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'error': instance.error,
      'data': instance.data,
      'weeks': instance.weeks,
      'id': instance.id,
      'type': instance.type,
      'currentWeek': instance.currentWeek,
    };

ScheduleResponse _$ScheduleResponseFromJson(Map<String, dynamic> json) =>
    ScheduleResponse(
      json['isSuccess'] as bool,
      json['error'] as String,
      scheduleModels: (json['scheduleModels'] as List<dynamic>?)
              ?.map((e) => ScheduleModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    )..data = json['data'];

Map<String, dynamic> _$ScheduleResponseToJson(ScheduleResponse instance) =>
    <String, dynamic>{
      'isSuccess': instance.isSuccess,
      'error': instance.error,
      'data': instance.data,
      'scheduleModels': instance.scheduleModels,
    };
