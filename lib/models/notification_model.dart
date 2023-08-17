import 'package:flutter/material.dart';
import '../utils/utils.dart';

import 'package:json_annotation/json_annotation.dart';

part 'notification_model.g.dart';

@JsonSerializable()
class NotificationModel {
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
  int messageId = -1;
  int notificationImportanceId = 3;

  NotificationModel(
      {this.title = "undefined",
      this.message = "undefined",
      this.dateOfCreation = "",
      this.dateOfReading = "",
      this.actionData = "",
      this.actionType = "",
      this.activityKindColor = "FFB40C",
      this.activityKindIcon = "/images/icons/education.png",
      this.activityKindName = "Учебная деятельность",
      this.categoryId = 4,
      this.messageId = -1,
      this.notificationImportanceId = 3});

  factory NotificationModel.fromJson(Map<String, dynamic> json) => _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);
  Widget getView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(children: [
        Stack(
          children: <Widget>[
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(24), // Image radius
                child: Container(
                  decoration: BoxDecoration(
                    color: HexColor.fromHex(activityKindColor).withAlpha(200),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(6),
                    child: Image.network(
                        'https://ecampus.ncfu.ru$activityKindIcon',
                        color: Colors.white,
                        fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
            dateOfReading == "unread"
                ? Positioned(
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 12,
                        minHeight: 12,
                      ),
                    ),
                  )
                : const SizedBox.shrink()
          ],
        ),
        const SizedBox(
          width: 12,
        ),
        Flexible(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 2,
            ),
            Text(
              message,
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        )),
      ]),
    );
  }
}
