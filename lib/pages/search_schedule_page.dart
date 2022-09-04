import 'dart:developer';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/map_marker_model.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/models/search_schedule_model.dart';
import 'package:ecampus_ncfu/pages/schedule_page.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SearchSchedule extends StatefulWidget {
  const SearchSchedule({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  State<SearchSchedule> createState() => _SearchScheduleState();
}

class _SearchScheduleState extends State<SearchSchedule> {
  eCampus? ecampus;
  List<SearchScheduleResult>? models;
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
        titleSpacing: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0.5,
        title: Padding(
          padding: EdgeInsets.only(right: 12),
          child: CupertinoSearchTextField(
            autofocus: true,
            placeholder: "Поиск",
            style: Theme.of(context).textTheme.bodyMedium,
            onChanged: (value) {
              if (value.length >= 2) {
                ecampus!.searchSchedule(value).then((response) {
                  if (response.isSuccess) {
                    setState(() {
                      models = response.models;
                    });
                  } else {
                    models = [];
                  }
                });
              } else {
                setState(() {
                  models = null;
                });
              }
            },
          ),
        ),
      ),
      body: Center(
        child: models != null
            ? models!.isNotEmpty
                ? ListView(
                    children: models!
                        .map(
                          (e) => CrossListElement(
                            onPressed: () {
                              Navigator.push(
                                context,
                                CupertinoPageRoute(
                                  builder: (context) => SchedulePage(
                                    context: context,
                                    url: e.url,
                                    title: e.title,
                                  ),
                                ),
                              );
                            },
                            child: e.getView(context),
                          ),
                        )
                        .toList())
                : Center(
                    child: Image.asset("images/not_found.png"),
                  )
            : Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Для поиска расписания введите фамилию преподавателя, название группы или номер аудитории, например Петров, ИС-011, 9-317.",
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
      ),
    );
  }
}
