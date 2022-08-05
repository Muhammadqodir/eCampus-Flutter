import 'dart:typed_data';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;
  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  eCampus? ecampus;
  List<NotificationModel>? notifications;
  double elevation = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sPref) => {
          ecampus = eCampus(sPref.getString("token")!),
          update(),
        });
  }

  void update() {
    setState(() {
      notifications = null;
    });
    ecampus!.getNotifications().then((response) => {
          if (response.isSuccess)
            {
              setState(
                  (() => {notifications = response.unread! + response.read!}))
            }
          else
            {print("error" + response.error)}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          child: Icon(EcampusIcons.icons8_back),
        ),
        actions: [
          CupertinoButton(
            onPressed: update,
            child: Icon(EcampusIcons.icons8_restart),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        title: Text(
          "Уведомления",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Center(
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            print(notification.metrics.pixels);
            if(notification.metrics.pixels > 0 && elevation == 0){
              setState(() {
                elevation = 0.5;
              });
            }
            if(notification.metrics.pixels < 0 && elevation != 0){
              setState(() {
                elevation = 0;
              });
            }
            return true;
          },
            child: CustomScrollView(
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                update();
              },
            ),
            SliverList(
                delegate: SliverChildListDelegate([
              Column(
                children: <Widget>[
                  notifications != null
                      ? Column(
                          children: notifications!
                              .map((element) => element.getView(context))
                              .toList(),
                        )
                      : Column(children: [
                        getNotificationSkeleton(context),
                        getNotificationSkeleton(context),
                        getNotificationSkeleton(context),
                        getNotificationSkeleton(context),
                        getNotificationSkeleton(context),
                      ],)
                ],
              ),
              SizedBox(height: 12,)
            ]))
          ],
        )),
      ),
    );
  }
}
