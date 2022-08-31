// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationModelFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      title: json['title'] as String? ?? "undefined",
      message: json['message'] as String? ?? "undefined",
      dateOfCreation: json['dateOfCreation'] as String? ?? "",
      dateOfReading: json['dateOfReading'] as String? ?? "",
      actionData: json['actionData'] as String? ?? "",
      actionType: json['actionType'] as String? ?? "",
      activityKindColor: json['activityKindColor'] as String? ?? "FFB40C",
      activityKindIcon:
          json['activityKindIcon'] as String? ?? "/images/icons/education.png",
      activityKindName:
          json['activityKindName'] as String? ?? "Учебная деятельность",
      categoryId: json['categoryId'] as int? ?? 4,
      notificationImportanceId: json['notificationImportanceId'] as int? ?? 3,
    );

Map<String, dynamic> _$NotificationModelToJson(NotificationModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'message': instance.message,
      'dateOfCreation': instance.dateOfCreation,
      'dateOfReading': instance.dateOfReading,
      'actionData': instance.actionData,
      'actionType': instance.actionType,
      'activityKindColor': instance.activityKindColor,
      'activityKindIcon': instance.activityKindIcon,
      'activityKindName': instance.activityKindName,
      'categoryId': instance.categoryId,
      'notificationImportanceId': instance.notificationImportanceId,
    };
