// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject_models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcademicYearsModel _$AcademicYearsModelFromJson(Map<String, dynamic> json) =>
    AcademicYearsModel(
      json['kursTypeName'] as String,
      json['name'] as String,
      json['id'] as int,
      json['parentId'] as int,
      json['isCurrent'] as bool,
      (json['termModels'] as List<dynamic>)
          .map((e) => TermModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$AcademicYearsModelToJson(AcademicYearsModel instance) =>
    <String, dynamic>{
      'kursTypeName': instance.kursTypeName,
      'name': instance.name,
      'id': instance.id,
      'parentId': instance.parentId,
      'isCurrent': instance.isCurrent,
      'termModels': instance.termModels,
    };

TermModel _$TermModelFromJson(Map<String, dynamic> json) => TermModel(
      json['isCurrent'] as bool,
      json['termTypeName'] as String,
      json['name'] as String,
      json['parentId'] as int,
      json['id'] as int,
    );

Map<String, dynamic> _$TermModelToJson(TermModel instance) => <String, dynamic>{
      'isCurrent': instance.isCurrent,
      'termTypeName': instance.termTypeName,
      'name': instance.name,
      'parentId': instance.parentId,
      'id': instance.id,
    };

SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) => SubjectModel(
      id: json['id'] as int,
      parentId: json['parentId'] as int,
      name: json['name'] as String,
      teacherName: json['teacherName'] as String? ?? "",
      teacherId: json['teacherId'] as int? ?? -1,
      termsForAtt: json['termsForAtt'] as String,
      subType: json['subType'] as String,
      currentRating: (json['currentRating'] as num).toDouble(),
      maxRating: (json['maxRating'] as num).toDouble(),
      locked: json['locked'] as bool,
      lessonTypes: (json['lessonTypes'] as List<dynamic>)
          .map((e) => LessonTypesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      hasInstruction: json['hasInstruction'] as bool,
      hasLectures: json['hasLectures'] as bool,
      hasUMK: json['hasUMK'] as bool,
      isConfirmDocumentExists: json['isConfirmDocumentExists'] as bool,
    );

Map<String, dynamic> _$SubjectModelToJson(SubjectModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'teacherName': instance.teacherName,
      'teacherId': instance.teacherId,
      'termsForAtt': instance.termsForAtt,
      'subType': instance.subType,
      'parentId': instance.parentId,
      'id': instance.id,
      'currentRating': instance.currentRating,
      'maxRating': instance.maxRating,
      'locked': instance.locked,
      'isConfirmDocumentExists': instance.isConfirmDocumentExists,
      'hasLectures': instance.hasLectures,
      'hasInstruction': instance.hasInstruction,
      'hasUMK': instance.hasUMK,
      'lessonTypes': instance.lessonTypes,
    };

LessonTypesModel _$LessonTypesModelFromJson(Map<String, dynamic> json) =>
    LessonTypesModel(
      id: json['id'] as int,
      parentId: json['parentId'] as int,
      kodPr: json['kodPr'] as int,
      lessonType: json['lessonType'] as int,
      name: json['name'] as String,
      schoolType: json['schoolType'] as bool,
    );

Map<String, dynamic> _$LessonTypesModelToJson(LessonTypesModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'schoolType': instance.schoolType,
      'lessonType': instance.lessonType,
      'kodPr': instance.kodPr,
      'parentId': instance.parentId,
      'id': instance.id,
    };

LessonItemModel _$LessonItemModelFromJson(Map<String, dynamic> json) =>
    LessonItemModel(
      id: json['id'] as int,
      attendance: json['attendance'] as int,
      gainedScore: (json['gainedScore'] as num).toDouble(),
      grade: (json['grade'] as num).toDouble(),
      kodPr: json['kodPr'] as int,
      loadId: json['loadId'] as int,
      lostScore: (json['lostScore'] as num).toDouble(),
      subject: json['subject'] as String,
      name: json['name'] as String,
      room: json['room'] as String,
      date: json['date'] as String,
      gradeText: json['gradeText'] as String,
      isCheckpoint: json['isCheckpoint'] as bool,
      hasFile: json['hasFile'] as bool,
    );

Map<String, dynamic> _$LessonItemModelToJson(LessonItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loadId': instance.loadId,
      'attendance': instance.attendance,
      'kodPr': instance.kodPr,
      'gainedScore': instance.gainedScore,
      'grade': instance.grade,
      'lostScore': instance.lostScore,
      'subject': instance.subject,
      'name': instance.name,
      'room': instance.room,
      'date': instance.date,
      'gradeText': instance.gradeText,
      'isCheckpoint': instance.isCheckpoint,
      'hasFile': instance.hasFile,
    };
