import 'dart:typed_data';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Uint8List? captchaImage;
  bool isLogined = true;
  bool loading = false;

  @override
  void initState() {
    super.initState();
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
            onPressed: () {},
            child: Icon(EcampusIcons.icons8_restart),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Уведомления",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Center(
          child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              //
            },
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Column(
              children: <Widget>[
                NotificationModel(
                  title: "title",
                  message: "message",
                  activityKindColor: "009AD1"
                ).getView(context)
              ],
            ),
          ]))
        ],
      )),
    );
  }
}
