import 'dart:developer';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class RecordBookItem {
  String discipline = "";
  String hours = "";
  String mark = "";
  String date = "";
  String teacher = "";
  String type = "";
  bool isOVR = false;

  RecordBookItem.buildDefault();

  RecordBookItem(
    this.discipline,
    this.hours,
    this.mark,
    this.date,
    this.teacher,
    this.type,
    this.isOVR,
  );

  String getDate() {
    log(date);
    if (date != "") {
      return DateFormat('dd.MM.yyyy').format(DateTime.parse(date));
    } else {
      return "";
    }
  }

  Color getScoreBgColor(BuildContext context) {
    if (mark == "неудовлетворительно" ||
        mark == "не зачтено" ||
        mark == "неявка") {
      return CustomColors.unsatisfactorily;
    } else {
      return Theme.of(context).textTheme.bodyMedium!.color!;
    }
  }

  Widget getView(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            discipline,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            type,
            style: Theme.of(context)
                .textTheme
                .bodyMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      EcampusIcons.icons8_teacher,
                      size: 19,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: Text(
                        "Преподаватель",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      teacher,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      EcampusIcons.icons8_star,
                      size: 19,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: Text(
                        "Оценка",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      mark,
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                          color: getScoreBgColor(context)),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      EcampusIcons.icons8_timer,
                      size: 19,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: Text(
                        "Общее кол-во часов",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      hours,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(
                      EcampusIcons.icons8_calendar,
                      size: 19,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Flexible(
                      child: Text(
                        "Дата сдачи",
                        overflow: TextOverflow.fade,
                        softWrap: false,
                        maxLines: 1,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      getDate(),
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecordBookCourseModel {
  String title = "";
  List<RecordBookTermModel> termModels = [];

  RecordBookCourseModel.buildDefault();

  RecordBookCourseModel(this.title, this.termModels);
}

class RecordBookTermModel {
  String title = "";
  List<RecordBookItem> items = [];

  RecordBookTermModel.buildDefault();

  RecordBookTermModel(this.title, this.items);

  List<int> getMarksCount() {
    List<int> res = List.filled(4, 0, growable: false);
    res[0] = 0;
    res[1] = 0;
    res[2] = 0;
    res[3] = 0;
    for (RecordBookItem item in items) {
      switch (item.mark) {
        case "отлично":
          res[3] += 1;
          break;
        case "хорошо":
          res[2] += 1;
          break;
        case "удовлетворительно":
          res[1] += 1;
          break;
        case "неудовлетворительно":
          res[0] += 1;
          break;
      }
    }
    return res;
  }
}

class RecordBookTabTitle {
  String title = "";
  int otl = 0;
  int xor = 0;
  int udov = 0;
  int neud = 0;

  RecordBookTabTitle.buildDefault();

  RecordBookTabTitle(this.title, this.otl, this.xor, this.udov, this.neud);
}
