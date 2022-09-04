import 'dart:developer';

import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/models/teacher_model.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_database/firebase_database.dart';

class MyTeachersPage extends StatefulWidget {
  MyTeachersPage({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;
  final FirebaseDatabase database = FirebaseDatabase.instance;

  @override
  State<MyTeachersPage> createState() => _MyTeachersPageState();
}

class _MyTeachersPageState extends State<MyTeachersPage> {
  eCampus? ecampus;
  List<TeacherModel>? models;
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
    isOnline().then(
      (isOnline) => {
        if (isOnline)
          {
            setState(() {
              models = null;
            }),
            ecampus!.getMyTeachers().then((response) {
              if (response.isSuccess) {
                CacheSystem.saveMyTeachers(response);
                setState(() {
                  models = response.teachers;
                });
              } else {
                if (response.error == "Status code 302") {
                  ecampus?.getCaptcha().then((captchaImage) {
                    showCapchaDialog(context, captchaImage, ecampus!, update);
                  });
                } else {
                  log(response.error);
                }
              }
            }),
          }
        else
          {
            showOfflineDialog(context),
          }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          child: const Icon(EcampusIcons.icons8_back),
        ),
        actions: [
          CupertinoButton(
            onPressed: update,
            child: const Icon(EcampusIcons.icons8_restart),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        title: Text(
          "Мои преподаватели",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: Center(
        child: NotificationListener<ScrollUpdateNotification>(
          onNotification: (notification) {
            if (notification.metrics.pixels > 0 && elevation == 0) {
              setState(() {
                elevation = 0.5;
              });
            }
            if (notification.metrics.pixels <= 0 && elevation != 0) {
              setState(() {
                elevation = 0;
              });
            }
            return true;
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: [
              CupertinoSliverRefreshControl(
                onRefresh: () async {
                  update();
                },
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: <Widget>[
                        models != null
                            ? Column(
                                children: models!
                                    .map(
                                      (element) => CrossListElement(
                                        onPressed: () {},
                                        child: element.getView(
                                            context, ecampus!, widget.database),
                                      ),
                                    )
                                    .toList(),
                              )
                            : Column(
                                children: [
                                  getNotificationSkeleton(context),
                                  getNotificationSkeleton(context),
                                  getNotificationSkeleton(context),
                                  getNotificationSkeleton(context),
                                  getNotificationSkeleton(context),
                                ],
                              )
                      ],
                    ),
                    const SizedBox(
                      height: 12,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
