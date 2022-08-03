import 'package:ecampus_ncfu/pages/notifications_page.dart';
import 'package:flutter/material.dart';

class NotificationModel{
  String title;
  String message = "undefined";
  String dateOfCreation = "";
  String dateOfReading = "";
  String actionData;
  String actionType;
  String activityKindColor = "FFB40C";
  String activityKindIcon = "/images/icons/education.png";
  String activityKindName = "Учебная деятельность";
  int categoryId = 4;
  int notificationImportanceId = 3;

  NotificationModel({
    this.title = "undefined", 
    this.message = "undefined", 
    this.dateOfCreation = "",
    this.dateOfReading = "",
    this.actionData = "",
    this.actionType = "",
    this.activityKindColor = "FFB40C",
    this.activityKindIcon = "/images/icons/education.png",
    this.activityKindName = "Учебная деятельность",
    this.categoryId = 4,
    this.notificationImportanceId = 3
    });

}