import 'dart:developer';

import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/bottom_nav.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/inc/week_tab.dart';
import 'package:ecampus_ncfu/models/schedule_models.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

const double _kItemExtent = 32.0;

class ContentSchedule extends StatefulWidget {
  const ContentSchedule({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<ContentSchedule> createState() => _ContentScheduleState();
}

class _ContentScheduleState extends State<ContentSchedule> {
  int selectedIndex = 0;
  late eCampus ecampus;
  bool loading = true;
  List<ScheduleWeeksModel> weeks = [];
  String selectedWeek = "";

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      ecampus = eCampus(value.getString("token") ?? "undefined");
      fillData();
    });
  }

  PageController _pageController = PageController();

  void setSelected(int value) {
    setState(() {
      selectedIndex = value;
      _pageController.animateToPage(selectedIndex,
          duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  int selectedWeekId = 0;
  int scheduleId = 0;
  int targetType = 0;
  String currentWeekDate = "";
  List<ScheduleModel> scheduleModels = [];

  ScheduleModel? getScheduleModel(String weekDay_) {
    for (var model in scheduleModels) {
      if (model.weekDay == weekDay_) {
        return model;
      }
    }
    return null;
  }

  void fillData() {
    CacheSystem.getScheduleWeeksResponse().then((weeksResponse) {
      if (weeksResponse != null) {
        if (weeksResponse.isActualCache()) {
          ScheduleWeeksResponse value = weeksResponse.value;
          setState(() {
            weeks = value.weeks;
            scheduleId = value.id;
            targetType = value.type;
            selectedWeekId = value.currentWeek;
            currentWeekDate = weeks[selectedWeekId].dateBegin;
            selectedWeek =
                "${weeks[selectedWeekId].number} неделя - c ${weeks[selectedWeekId].getStrDateBegin()} по ${weeks[selectedWeekId].getStrDateEnd()}";
            CacheSystem.getScheduleResponse().then((schedule) {
              setState(() {
                loading = false;
                scheduleModels = schedule!.value.scheduleModels;
                selectedIndex = DateTime.now().weekday == 7
                    ? 1
                    : DateTime.now().weekday - 1;
              });
              _pageController = PageController(initialPage: selectedIndex);
            });
          });
        } else {
          getWeeks();
        }
      } else {
        getWeeks();
      }
    });
  }

  void getWeeks() {
    isOnline().then((value) {
      if (value) {
        setState(() {
          loading = true;
        });
        ecampus.isActualToken().then((isActualToken) {
          if (isActualToken) {
            ecampus.getScheduleWeeks().then((value) {
              if (value.isSuccess) {
                setState(() {
                  CacheSystem.saveScheduleWeeksResponse(value);
                  weeks = value.weeks;
                  scheduleId = value.id;
                  targetType = value.type;
                  selectedWeekId = value.currentWeek;
                  currentWeekDate = weeks[selectedWeekId].dateBegin;
                  selectedWeek =
                      "${weeks[selectedWeekId].number} неделя - c ${weeks[selectedWeekId].getStrDateBegin()} по ${weeks[selectedWeekId].getStrDateEnd()}";
                  getSchedule(weeks[selectedWeekId].dateBegin);
                });
              } else {
                showAlertDialog(context, "Ошибка", value.error);
              }
            });
          } else {
            ecampus.getCaptcha().then((captcha) {
              showCapchaDialog(context, captcha, ecampus, () {
                getWeeks();
              });
            });
          }
        });
      } else {
        showOfflineDialog(context);
      }
    });
  }

  void getSchedule(String date) {
    isOnline().then((value) {
      if (value) {
        setState(() {
          loading = true;
        });
        ecampus.isActualToken().then((isActualToken) {
          if (isActualToken) {
            ecampus.getSchedule(date, scheduleId, targetType).then((value) {
              if (value.isSuccess) {
                setState(() {
                  if (date == currentWeekDate) {
                    CacheSystem.saveScheduleResponse(value);
                    selectedIndex = DateTime.now().weekday - 1;
                  }
                  _pageController = PageController(initialPage: selectedIndex);
                  scheduleModels = value.scheduleModels;
                  loading = false;
                });
              } else {
                showAlertDialog(context, "Ошибка", value.error);
              }
            });
          } else {
            ecampus.getCaptcha().then((captcha) {
              showCapchaDialog(context, captcha, ecampus, () {
                getSchedule(date);
              });
            });
          }
        });
      } else {
        showOfflineDialog(context);
      }
    });
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoPicker.
  void showSelectWeekDialog() {
    FixedExtentScrollController extentScrollController =
        FixedExtentScrollController(initialItem: selectedWeekId);
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
                    setState(() {
                      selectedWeek =
                          "${weeks[selectedItem].number} неделя - c ${weeks[selectedItem].getStrDateBegin()} по ${weeks[selectedItem].getStrDateEnd()}";
                    });
                  },
                  children: List<Widget>.generate(
                    weeks.length,
                    (int index) {
                      return Center(
                        child: Text(
                          "${weeks[index].number} неделя - c ${weeks[index].getStrDateBegin()} по ${weeks[index].getStrDateEnd()}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    },
                  ),
                ),
              ),
              CupertinoButton(
                child: Text(
                  "Выбрать",
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                onPressed: () {
                  setState(() {
                    selectedWeekId = extentScrollController.selectedItem;
                  });
                  getSchedule(weeks[selectedWeekId].dateBegin);
                  Navigator.pop(context);
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  final List<AssetImage> freeIllustrations = [
    const AssetImage("images/free_1.png"),
    const AssetImage("images/free_2.png"),
    const AssetImage("images/free_3.png"),
    const AssetImage("images/free_4.png"),
  ];

  DateTime lastPageChange = DateTime.now();

  @override
  Widget build(BuildContext context) {
    double dWidth = MediaQuery.of(context).size.width;
    return loading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(
                  radius: 12,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  "Загрузка...",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
              ],
            ),
          )
        : Column(
            children: [
              WeekTab(
                start: weeks[selectedWeekId].getDateBegin(),
                selectedIndex: selectedIndex,
                setSelected: setSelected,
              ),
              Expanded(
                child: NotificationListener<ScrollUpdateNotification>(
                  onNotification: (overscroll) {
                    double scWidth = MediaQuery.of(context).size.width;
                    if (overscroll.metrics.viewportDimension == scWidth) {
                      double minScroll = dWidth - (dWidth * 1.2);
                      if (overscroll.metrics.pixels < minScroll &&
                          DateTime.now().isAfter(
                              lastPageChange.add(const Duration(seconds: 1)))) {
                        lastPageChange = DateTime.now();
                        log("left");
                        if (selectedWeekId > 0) {
                          setState(() {
                            getSchedule(weeks[selectedWeekId - 1].dateBegin);
                            selectedWeekId -= 1;
                            selectedIndex = 6;
                            selectedWeek =
                                "${weeks[selectedWeekId].number} неделя - c ${weeks[selectedWeekId].getStrDateBegin()} по ${weeks[selectedWeekId].getStrDateEnd()}";
                          });
                        }
                      }
                      if (overscroll.metrics.pixels > dWidth * 6.2 &&
                          DateTime.now().isAfter(
                              lastPageChange.add(const Duration(seconds: 1)))) {
                        lastPageChange = DateTime.now();
                        log("right");
                        if (selectedIndex < weeks.length) {
                          setState(() {
                            getSchedule(weeks[selectedWeekId + 1].dateBegin);
                            selectedWeekId += 1;
                            selectedIndex = 0;
                            selectedWeek =
                                "${weeks[selectedWeekId].number} неделя - c ${weeks[selectedWeekId].getStrDateBegin()} по ${weeks[selectedWeekId].getStrDateEnd()}";
                          });
                        }
                      }
                    }
                    return false;
                  },
                  child: PageView(
                      controller: _pageController,
                      onPageChanged: (value) {
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      children: WeekTab.weekDays
                          .map(
                            (e) => getScheduleModel(WeekTab.weekAbbrv[e]!) !=
                                    null
                                ? ListView(
                                    children:
                                        getScheduleModel(WeekTab.weekAbbrv[e]!)!
                                            .lessons
                                            .map(
                                              (lesson) => CrossListElement(
                                                onPressed: () {},
                                                child: lesson.getView(context),
                                              ),
                                            )
                                            .toList())
                                : ListView(
                                    shrinkWrap: true,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(20),
                                        child: Image(
                                          image: freeIllustrations[0],
                                        ),
                                      ),
                                      Text(
                                        "Для данного дня рассписание не\nпредоставлено",
                                        textAlign: TextAlign.center,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor),
                                      ),
                                    ],
                                  ),
                          )
                          .toList()),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 0, top: 0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: CupertinoButton(
                        child: const Icon(EcampusIcons.icons8_back),
                        onPressed: () {
                          if (selectedWeekId > 0) {
                            setState(() {
                              selectedWeekId -= 1;
                              selectedWeek =
                                  "${weeks[selectedWeekId].number} неделя - c ${weeks[selectedWeekId].getStrDateBegin()} по ${weeks[selectedWeekId].getStrDateEnd()}";
                              getSchedule(weeks[selectedWeekId].dateBegin);
                            });
                          }
                        },
                      ),
                    ),
                    Expanded(
                      child: Center(
                        child: OnTapScaleAndFade(
                          onTap: () => showSelectWeekDialog(),
                          child: Text(
                            selectedWeek,
                            textAlign: TextAlign.center,
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50,
                      child: CupertinoButton(
                        child: const Icon(EcampusIcons.icons8_forward),
                        onPressed: () {
                          if (selectedIndex < weeks.length) {
                            setState(() {
                              selectedWeekId += 1;
                              selectedWeek =
                                  "${weeks[selectedWeekId].number} неделя - c ${weeks[selectedWeekId].getStrDateBegin()} по ${weeks[selectedWeekId].getStrDateEnd()}";
                              getSchedule(weeks[selectedWeekId].dateBegin);
                            });
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
  }
}
