import 'package:ecampus_ncfu/pages/notifications_page.dart';
import 'package:flutter/material.dart';

import '../utils/gui_utils.dart';
import '../utils/utils.dart';

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
      this.notificationImportanceId = 3});

  Widget getView(BuildContext context) {
    return CupertinoInkWell(
      onPressed: (() {}),
      child: Container(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(children: [
            ClipOval(
              child: SizedBox.fromSize(
                size: const Size.fromRadius(24), // Image radius
                child: Container(
                    decoration: BoxDecoration(
                      color: HexColor.fromHex(activityKindColor),
                    ),
                    child: Padding(
                        padding: const EdgeInsets.all(6),
                        child: Image.network(
                            'https://ecampus.ncfu.ru$activityKindIcon',
                            color: Colors.white,
                            fit: BoxFit.cover))),
              ),
            ),
            SizedBox(
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
                SizedBox(
                  height: 2,
                ),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ],
            )),
          ]),
        ),
      ),
    );
  }
}
