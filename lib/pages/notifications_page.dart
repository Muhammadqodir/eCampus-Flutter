import 'dart:developer';

import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({
    Key? key,
  }) : super(key: key);

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
    ecampus = context.read<ApiCubit>().state.api;
    update();
  }

  void update() {
    isOnline().then(
      (isOnline) => {
        if (isOnline)
          {
            setState(() {
              notifications = null;
            }),
            ecampus!.getNotifications().then((response) {
              if (response.isSuccess) {
                setState(() {
                  notifications = response.unread! + response.read!;
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
            // To send to the server about the button response
            context.read<ApiCubit>().state.api.sendStat(
                  "Pushed_back_btn",
                  extra: "Notification page",
                );

            Navigator.pop(context);
          }),
          child: const Icon(EcampusIcons.icons8_back),
        ),
        actions: [
          CupertinoButton(
            onPressed: () {
              // To send to the server about the button response
              context.read<ApiCubit>().state.api.sendStat(
                    "Pushed_refresh_btn",
                    extra: "Notification page",
                  );

              update();
            },
            child: const Icon(EcampusIcons.icons8_restart),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        title: Text(
          "Уведомления",
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
                  // To send to the server about the button response
                  context.read<ApiCubit>().state.api.sendStat(
                        "Refreshed",
                        extra: "Notification page",
                      );

                  update();
                },
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Column(
                      children: <Widget>[
                        notifications != null
                            ? Column(
                                children: notifications!
                                    .map(
                                      (element) => CrossListElement(
                                        onPressed: () {
                                          // Navigator.push(
                                          //   context,
                                          //   CupertinoPageRoute(
                                          //     builder: (context) =>
                                          //         ChatPage(
                                          //       context: context,
                                          //     ),
                                          //   ),
                                          // );
                                        },
                                        child: element.getView(context),
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
                    ),
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
