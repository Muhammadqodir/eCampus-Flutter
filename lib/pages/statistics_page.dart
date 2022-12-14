import 'dart:developer';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/cross_activity_indicator.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:ecampus_ncfu/pages/statistics_details_page.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

const double _kItemExtent = 32.0;

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  eCampus? ecampus;
  double elevation = 0;
  bool loading = true;
  bool dataCollection = false;
  double progressPos = 0;
  double progressMaxPos = 0;
  int studentId = 0;
  List<LessonItemModel> ushki = [];
  List<LessonItemModel> nki = [];
  List<LessonItemModel> fillKT = [];
  List<LessonItemModel> openKT = [];
  String subjectStr = "";
  String loadingText = "";

  List<String> exams = [];
  List<String> dif = [];
  List<String> credits = [];

  @override
  void initState() {
    super.initState();
    Appodeal.show(AppodealAdType.Interstitial);
    SharedPreferences.getInstance().then(
      (sPref) {
        ecampus = eCampus(sPref.getString("token")!);
        getStat();
      },
    );
  }

  int selectedTermIndex = 0;
  void showSelectTermDialog() {
    FixedExtentScrollController extentScrollController =
        FixedExtentScrollController(initialItem: selectedTermIndex);
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 250,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: CupertinoPicker(
                  scrollController: extentScrollController,
                  magnification: 1.22,
                  squeeze: 1.2,
                  useMagnifier: false,
                  looping: false,
                  itemExtent: _kItemExtent,
                  // This is called when selected item is changed.
                  onSelectedItemChanged: (int selectedItem) {
                    SystemSound.play(SystemSoundType.click);
                    HapticFeedback.mediumImpact();
                  },
                  children:
                      List<Widget>.generate(termNames.length, (int index) {
                    return Center(
                      child: Text(
                        termNames[index],
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    );
                  }),
                ),
              ),
              CupertinoButton(
                child: Text(
                  "??????????????",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                onPressed: () {
                  setState(() {
                    selectedTermIndex = extentScrollController.selectedItem;
                  });
                  getStatForTerm(termModels[selectedTermIndex].id);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  List<AcademicYearsModel> yearModels = [];
  List<TermModel> termModels = [];
  List<String> termNames = [];
  void getStat() async {
    setState(() {
      loading = true;
      dataCollection = false;
    });
    if (await isOnline()) {
      if (await ecampus!.isActualToken()) {
        AcademicYearsResponse academicYearsResponse =
            await ecampus!.getAcademicYears();
        if (academicYearsResponse.isSuccess) {
          List<SubjectModel> models =
              academicYearsResponse.currentSubjects!.models;
          termModels = [];
          yearModels = academicYearsResponse.models!;
          bool enough = false;
          for (AcademicYearsModel academicYearsModel in yearModels) {
            for (TermModel model in academicYearsModel.termModels) {
              termModels.add(model);
              if (model.isCurrent) {
                enough = true;
                break;
              }
            }
            if (enough) {
              break;
            }
          }
          for (int i = 0; i < termModels.length; i++) {
            termNames.add("${termModels[i].name} ??????????????");
          }
          setState(() {
            selectedTermIndex = termModels.length - 1;
            dataCollection = true;
            studentId = academicYearsResponse.studentId ?? 0;
            progressMaxPos = models.length.toDouble();
            progressPos = 0;
          });
          for (int i = 0; i < models.length; i++) {
            log(models[i].name);
            switch (models[i].subType) {
              case "??????????":
                credits.add(models[i].name);
                break;
              case "???????????????????????????????????? ??????????":
                dif.add(models[i].name);
                break;
              case "??????????????":
                exams.add(models[i].name);
                break;
            }
            final int position = i;
            setState(() {
              subjectStr = models[position].name;
              progressPos += 1;
            });
            for (int j = 0; j < models[i].lessonTypes.length; j++) {
              LessonItemsResponse lessons = await ecampus!
                  .getLessonItems(studentId, models[i].lessonTypes[j].id);
              if (lessons.isSuccess) {
                List<LessonItemModel> lessonItems = lessons.models;
                for (int k = 0; k < lessonItems.length; k++) {
                  final int lPos = k;

                  if (lessonItems[lPos].date.isNotEmpty &&
                      DateTime.parse(lessonItems[lPos].date)
                          .isBefore(DateTime.now())) {
                    if (lessonItems[lPos].isCheckpoint) {
                      if (lessonItems[lPos].gradeText == "????????????" ||
                          lessonItems[lPos].gradeText == "??????????????????????????????????" ||
                          lessonItems[lPos].gradeText == "??????????????" ||
                          lessonItems[lPos].gradeText ==
                              "??????????????????????????????????????") {
                        lessonItems[lPos].subject = subjectStr;
                        fillKT.add(lessonItems[lPos]);
                        fillKT[fillKT.length - 1].subject == subjectStr;
                      } else {
                        lessonItems[lPos].subject = subjectStr;
                        openKT.add(lessonItems[lPos]);
                        openKT[openKT.length - 1].subject = subjectStr;
                      }
                    }
                  }
                  if (lessonItems[lPos].attendance == 0) {
                    nki.add(lessonItems[lPos]);
                    nki[nki.length - 1].subject = subjectStr;
                  }
                  if (lessonItems[lPos].attendance == 2) {
                    ushki.add(lessonItems[lPos]);
                    ushki[ushki.length - 1].subject = subjectStr;
                  }
                  setState(() {
                    loadingText = "$subjectStr(${lessonItems[lPos].name})";
                  });
                }
              }
            }
          }
          setState(() {
            loading = false;
          });
        } else {
          showAlertDialog(context, "????????????", academicYearsResponse.error);
        }
      } else {
        showCapchaDialog(context, await ecampus!.getCaptcha(), ecampus!, () {
          getStat();
        });
      }
    } else {
      showOfflineDialog(context);
    }
  }

  void getStatForTerm(int termId) async {
    setState(() {
      loading = true;
      dataCollection = false;

      ushki = [];
      nki = [];
      fillKT = [];
      openKT = [];

      exams = [];
      dif = [];
      credits = [];
    });
    if (await isOnline()) {
      if (await ecampus!.isActualToken()) {
        SubjectsResponse subjectsResponse =
            await ecampus!.getSubjects(studentId, termId);
        if (subjectsResponse.isSuccess) {
          List<SubjectModel> models = subjectsResponse.models;
          setState(() {
            dataCollection = true;
            progressMaxPos = models.length.toDouble();
            progressPos = 0;
          });
          for (int i = 0; i < models.length; i++) {
            log(models[i].name);
            switch (models[i].subType) {
              case "??????????":
                credits.add(models[i].name);
                break;
              case "???????????????????????????????????? ??????????":
                dif.add(models[i].name);
                break;
              case "??????????????":
                exams.add(models[i].name);
                break;
            }
            final int position = i;
            setState(() {
              subjectStr = models[position].name;
              progressPos += 1;
            });
            for (int j = 0; j < models[i].lessonTypes.length; j++) {
              LessonItemsResponse lessons = await ecampus!
                  .getLessonItems(studentId, models[i].lessonTypes[j].id);
              if (lessons.isSuccess) {
                List<LessonItemModel> lessonItems = lessons.models;
                for (int k = 0; k < lessonItems.length; k++) {
                  final int lPos = k;

                  if (lessonItems[lPos].date.isNotEmpty &&
                      DateTime.parse(lessonItems[lPos].date)
                          .isBefore(DateTime.now())) {
                    if (lessonItems[lPos].isCheckpoint) {
                      if (lessonItems[lPos].gradeText == "????????????" ||
                          lessonItems[lPos].gradeText == "??????????????????????????????????" ||
                          lessonItems[lPos].gradeText == "??????????????" ||
                          lessonItems[lPos].gradeText ==
                              "??????????????????????????????????????") {
                        lessonItems[lPos].subject = subjectStr;
                        fillKT.add(lessonItems[lPos]);
                        fillKT[fillKT.length - 1].subject = subjectStr;
                      } else {
                        lessonItems[lPos].subject = subjectStr;
                        openKT.add(lessonItems[lPos]);
                        openKT[openKT.length - 1].subject = subjectStr;
                      }
                    }
                  }
                  if (lessonItems[lPos].attendance == 0) {
                    nki.add(lessonItems[lPos]);
                    nki[nki.length - 1].subject = subjectStr;
                  }
                  if (lessonItems[lPos].attendance == 2) {
                    ushki.add(lessonItems[lPos]);
                    ushki[ushki.length - 1].subject = subjectStr;
                  }
                  setState(() {
                    loadingText = "$subjectStr(${lessonItems[lPos].name})";
                  });
                }
              }
            }
          }
          setState(() {
            loading = false;
          });
        } else {
          showAlertDialog(context, "????????????", subjectsResponse.error);
        }
      } else {
        showCapchaDialog(context, await ecampus!.getCaptcha(), ecampus!, () {
          getStat();
        });
      }
    } else {
      showOfflineDialog(context);
    }
  }

  Widget countButton(
      {required String title,
      required int count,
      required Color color,
      required Function() onTap}) {
    return CrossButton(
      onPressed: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      backgroundColor: Theme.of(context).primaryColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  color: Colors.white,
                ),
          ),
          const SizedBox(
            width: 4,
          ),
          Container(
            alignment: Alignment.center,
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              count.toString(),
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                  ),
            ),
          )
        ],
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    int otl = 0;
    int xor = 0;
    int udov = 0;
    int neud = 0;
    for (int i = 0; i < fillKT.length; i++) {
      switch (fillKT[i].gradeText) {
        case "??????????????????????????????????????":
          neud += 1;
          break;
        case "??????????????????????????????????":
          udov += 1;
          break;
        case "????????????":
          xor += 1;
          break;
        case "??????????????":
          otl += 1;
          break;
      }
    }
    return [
      PieChartSectionData(
        value: neud.toDouble(),
        color: CustomColors.unsatisfactorily,
        title: "$neud\n????????.",
        showTitle: true,
        titleStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: udov.toDouble(),
        color: CustomColors.satisfactorily,
        title: "$udov\n????????",
        showTitle: true,
        titleStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: xor.toDouble(),
        color: CustomColors.good,
        title: "$xor\n??????.",
        showTitle: true,
        titleStyle: Theme.of(context)
            .textTheme
            .headlineSmall!
            .copyWith(fontWeight: FontWeight.bold),
      ),
      PieChartSectionData(
        value: otl.toDouble(),
        color: CustomColors.perfect,
        title: "$otl\n??????.",
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
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          child: const Icon(EcampusIcons.icons8_back),
        ),
        actions: [
          !loading
              ? CupertinoButton(
                  onPressed: () {
                    showSelectTermDialog();
                  },
                  child: Text(
                    termNames[selectedTermIndex],
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(color: Theme.of(context).primaryColor),
                  ),
                )
              : const SizedBox()
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        title: Text(
          "????????????????????",
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
          child: loading
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CrossActivityIndicator(
                      radius: 12,
                      color: Theme.of(context).textTheme.bodyLarge!.color!,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Text(
                      dataCollection ? "???????? ????????????..." : "????????????????...",
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                    dataCollection
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 12,
                                ),
                                Text(
                                  loadingText,
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.fade,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                SizedBox(
                                  height: 2,
                                  child: LinearProgressIndicator(
                                    value: progressPos / progressMaxPos,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                )
              : ListView(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [shadow],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "?????????????????????? ??????????",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    countButton(
                                      title: "???????????????? ????",
                                      count: openKT.length,
                                      color: CustomColors.error,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                StatisticsDetailsPage(
                                              context: context,
                                              title: "?????????????????????? ??????????",
                                              tabs: [
                                                StatisticsDetailsTab(
                                                  "???????????????? ????",
                                                  openKT.length,
                                                  CustomColors.error,
                                                  openKT,
                                                ),
                                                StatisticsDetailsTab(
                                                  "???????????????? ????",
                                                  fillKT.length,
                                                  CustomColors.warning,
                                                  fillKT,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    countButton(
                                      title: "???????????????? ????",
                                      count: fillKT.length,
                                      color: CustomColors.success,
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                            builder: (context) =>
                                                StatisticsDetailsPage(
                                              context: context,
                                              title: "?????????????????????? ??????????",
                                              tabs: [
                                                StatisticsDetailsTab(
                                                  "???????????????? ????",
                                                  openKT.length,
                                                  CustomColors.error,
                                                  openKT,
                                                ),
                                                StatisticsDetailsTab(
                                                  "???????????????? ????",
                                                  fillKT.length,
                                                  CustomColors.warning,
                                                  fillKT,
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                child: AspectRatio(
                                  aspectRatio: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: fillKT.isNotEmpty
                                        ? PieChart(
                                            PieChartData(
                                              sectionsSpace: 1,
                                              sections: showingSections(),
                                            ),
                                            swapAnimationDuration:
                                                const Duration(
                                                    milliseconds: 400),
                                          )
                                        : Center(
                                            child: Text(
                                              "???????????? ??????",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                            ),
                                          ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                    const AppodealBanner(
                      adSize: AppodealBannerSize.BANNER,
                    ),
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [shadow],
                      ),
                      child: Column(
                        children: [
                          Text(
                            "??????????????????",
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          Row(
                            children: [
                              Expanded(
                                child: countButton(
                                  title: "\"??\"????",
                                  count: nki.length,
                                  color: CustomColors.error,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            StatisticsDetailsPage(
                                          context: context,
                                          title: "??????????????????",
                                          tabs: [
                                            StatisticsDetailsTab(
                                              "\"??\"????",
                                              nki.length,
                                              CustomColors.error,
                                              nki,
                                            ),
                                            StatisticsDetailsTab(
                                              "\"??\"??????",
                                              ushki.length,
                                              CustomColors.warning,
                                              ushki,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Expanded(
                                child: countButton(
                                  title: "\"??\"??????",
                                  count: ushki.length,
                                  color: CustomColors.warning,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      CupertinoPageRoute(
                                        builder: (context) =>
                                            StatisticsDetailsPage(
                                          context: context,
                                          title: "??????????????????",
                                          tabs: [
                                            StatisticsDetailsTab(
                                              "\"??\"????",
                                              nki.length,
                                              CustomColors.error,
                                              nki,
                                            ),
                                            StatisticsDetailsTab(
                                              "\"??\"??????",
                                              ushki.length,
                                              CustomColors.warning,
                                              ushki,
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }
}
