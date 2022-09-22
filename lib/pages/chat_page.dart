import 'dart:developer';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/notification_model.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  eCampus? ecampus;
  double elevation = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sPref) {
      ecampus = eCampus(sPref.getString("token")!);
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
          child: const Icon(EcampusIcons.icons8_back),
        ),
        actions: [
          CupertinoButton(
            onPressed: () {},
            child: const Icon(EcampusIcons.icons8_restart),
          )
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        title: Text(
          "Чат",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                child: ListView(
                  children: [],
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).secondaryHeaderColor,
              ),
              child: CupertinoTextField(),
            ),
          ],
        ),
      ),
    );
  }
}
