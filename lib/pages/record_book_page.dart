import 'dart:developer';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/record_book_models.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RecordBookPage extends StatefulWidget {
  const RecordBookPage({Key? key, required this.context, required this.ecampus})
      : super(key: key);

  final BuildContext context;
  final eCampus ecampus;

  @override
  State<RecordBookPage> createState() => _RecordBookPageState();
}

class _RecordBookPageState extends State<RecordBookPage> {
  _RecordBookPageState();
  double elevation = 0;
  bool loading = true;
  List<RecordBookCourseModel> models = [];
  int selectedCourse = 0;

  void getData() async {
    setState(() {
      loading = true;
    });
    if (await isOnline()) {
      if (await widget.ecampus.isActualToken()) {
        RecordBookResponse response = await widget.ecampus.getRecordBook();
        if (response.isSuccess) {
          setState(() {
            models = response.models;
            selectedCourse = models.length - 1;
            loading = false;
          });
        } else {
          showAlertDialog(context, "Ошибка", response.error);
        }
      } else {
        showCapchaDialog(
            context, await widget.ecampus.getCaptcha(), widget.ecampus, () {
          getData();
        });
      }
    } else {
      showOfflineDialog(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  List<PieChartSectionData> getMarks(List<RecordBookItem> item) {
    int otl = 0;
    int xor = 0;
    int udov = 0;
    int neud = 0;
    for (int i = 0; i < item.length; i++) {
      switch (item[i].mark) {
        case "неудовлетворительно":
          neud += 1;
          break;
        case "удовлетворительно":
          udov += 1;
          break;
        case "хорошо":
          xor += 1;
          break;
        case "отлично":
          otl += 1;
          break;
      }
    }
    return [
      PieChartSectionData(
        value: neud.toDouble(),
        color: CustomColors.unsatisfactorily,
        title: "",
        showTitle: true,
        titleStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: udov.toDouble(),
        color: CustomColors.satisfactorily,
        title: "",
        showTitle: true,
        titleStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: xor.toDouble(),
        color: CustomColors.good,
        title: "",
        showTitle: true,
        titleStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: otl.toDouble(),
        color: CustomColors.perfect,
        title: "",
        showTitle: true,
        titleStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return !loading
        ? DefaultTabController(
            length: models[selectedCourse].termModels.length,
            child: Scaffold(
              appBar: AppBar(
                elevation: 0.5,
                leading: CupertinoButton(
                  onPressed: (() {
                    Navigator.pop(context);
                  }),
                  child: const Icon(EcampusIcons.icons8_back),
                ),
                title: Text(
                  "Зачётная книжка",
                  overflow: TextOverflow.fade,
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                bottom: TabBar(
                  tabs: models[selectedCourse]
                      .termModels
                      .map(
                        (e) => Tab(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                e.title,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              body: TabBarView(
                physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics(),
                ),
                children: models[selectedCourse]
                    .termModels
                    .map(
                      (e) => ListView(
                        children: e.items
                            .map(
                              (e) => CrossListElement(
                                onPressed: () {},
                                child: e.getView(context),
                              ),
                            )
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              elevation: 0,
              leading: CupertinoButton(
                onPressed: (() {
                  Navigator.pop(context);
                }),
                child: const Icon(EcampusIcons.icons8_back),
              ),
              title: Text(
                "Зачётная книжка",
                overflow: TextOverflow.fade,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            ),
            body: Center(
              child: Text(
                "Загрузка...",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          );
  }
}
