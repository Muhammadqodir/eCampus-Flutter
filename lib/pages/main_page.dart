import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/bottom_nav.dart';
import 'package:ecampus_ncfu/inc/fade_indexed_stack.dart';
import 'package:ecampus_ncfu/pages/contents/content_main.dart';
import 'package:ecampus_ncfu/pages/contents/content_schedule.dart';
import 'package:ecampus_ncfu/pages/contents/content_services.dart';
import 'package:ecampus_ncfu/pages/contents/content_subjects.dart';
import 'package:ecampus_ncfu/pages/login_page.dart';
import 'package:ecampus_ncfu/pages/my_teachers_page.dart';
import 'package:ecampus_ncfu/pages/notifications_page.dart';
import 'package:ecampus_ncfu/pages/search_schedule_page.dart';
import 'package:ecampus_ncfu/pages/statistics_page.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:new_version/new_version.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:package_info/package_info.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
    required this.title,
    required this.ecampus,
  }) : super(key: key);

  final String title;
  final eCampus ecampus;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;
  Uint8List? captchaImage;
  double elevation = 0;
  StatefulWidget? content;
  bool isActialToken = false;
  int notification_count = 0;

  int getPageIndex() {
    return pageIndex;
  }

  @override
  void initState() {
    content = ContentMain(
      context: context,
      setElevation: setAppbarElevation,
    );
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        // This is just a basic example. For real apps, you must show some
        // friendly dialog box before call the request method.
        // This is very important to not harm the user experience
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    isOnline().then((value) {
      if (value) {
        widget.ecampus.isActualToken().then((value) {
          isActialToken = value;
          if (value) {
            widget.ecampus.getNotificationSize().then((value) {
              log("Notifications: $value");
              setState(() {
                notification_count = value;
              });
            });
          }
        });

        versionCheck(context);
      }
    });
    super.initState();
  }

  void versionCheck(context) async {
    final FirebaseDatabase database = FirebaseDatabase.instance;
    final PackageInfo info = await PackageInfo.fromPlatform();
    String currentVersion = info.version;
    String packageName= info.packageName;
    log("Current version:$currentVersion");
    log("Package name:$packageName");
    database.ref("config/flutter/version").get().then((snapshot) {
      String dataJson = jsonEncode(snapshot.value);
      Map<String, dynamic> data = jsonDecode(dataJson);
      log("Store version: ${data["name"]}");
      if(currentVersion != data["name"]){
        showUpdateDialog(context, data["name"], packageName);
      }
    });
  }

  void setAppbarElevation(double visibility) {
    setState(() {
      elevation = visibility;
    });
  }

  bool bottomNavShadow = true;

  Container buildCustomBottomNavigaton(
      BuildContext ctx, List<CustomBottomNavItem> items) {
    return Container(
      height: 61,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).dividerColor,
            offset: const Offset(0, -0.5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            for (var item in items)
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      pageIndex = items.indexOf(item);
                      content = item.content;
                      elevation = 0;
                      if (pageIndex == 1) {
                        scheduleKey.currentState!.onPageActive();
                      } else if (pageIndex == 2) {
                        subjectsKey.currentState!.onPageActive();
                      }
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.fastOutSlowIn,
                    decoration: const BoxDecoration(
                      // color: pageIndex == items.indexOf(item)
                      //     ? Theme.of(ctx).primaryColor
                      //     : Theme.of(ctx).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.all(
                        Radius.circular(12),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Opacity(
                        opacity: pageIndex == items.indexOf(item) ? 1 : 0.6,
                        child: Column(
                          children: [
                            Icon(
                              item.icon,
                              size: 28,
                              color: pageIndex == items.indexOf(item)
                                  ? Theme.of(ctx).primaryColor
                                  : Theme.of(ctx).textTheme.titleSmall!.color,
                            ),
                            Text(
                              item.label,
                              maxLines: 1,
                              softWrap: false,
                              overflow: TextOverflow.ellipsis,
                              style: pageIndex == items.indexOf(item)
                                  ? Theme.of(ctx)
                                      .textTheme
                                      .titleSmall!
                                      .copyWith(
                                          color: Theme.of(ctx).primaryColor,
                                          fontWeight: FontWeight.bold)
                                  : Theme.of(ctx).textTheme.titleSmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  final GlobalKey<ContentSubjectsState> subjectsKey = GlobalKey();
  final GlobalKey<ContentScheduleState> scheduleKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;
    List<CustomBottomNavItem> bottomNavItems = [
      CustomBottomNavItem(
        "eCampus",
        CupertinoButton(
          child: Icon(
            EcampusIcons.icons8_logout_rounded_left,
            color: primaryColor,
          ),
          onPressed: () {
            showConfirmDialog(
                context, "?????????? ???? ??????????????", "?????????????????????? ????????????????", () {
              CacheSystem.invalidateAllCache();
              SharedPreferences.getInstance().then((value) => {
                    value.setBool("isLogin", false),
                    value.setString("ecampus", "undefined"),
                    Navigator.pushReplacement(
                      context,
                      CupertinoPageRoute(
                        builder: (context) => LoginPage(
                          context: context,
                        ),
                      ),
                    )
                  });
            });
          },
        ),
        [
          Stack(
            children: [
              CupertinoButton(
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Icon(
                      EcampusIcons.icons8_notification,
                      color: primaryColor,
                    ),
                    notification_count > 0
                        ? Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: CustomColors.error,
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => NotificationsPage(
                        context: context,
                      ),
                    ),
                  );
                },
              ),
            ],
          )
        ],
        ContentMain(
          context: context,
          setElevation: setAppbarElevation,
        ),
        EcampusIcons.icons8_student_male_1,
        '??????????????',
      ),
      CustomBottomNavItem(
        "????????????????????",
        CupertinoButton(
          child: Icon(
            EcampusIcons.icons8_teacher,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialWithModalsPageRoute(
                builder: (context) => MyTeachersPage(
                  context: context,
                ),
              ),
            );
          },
        ),
        [
          CupertinoButton(
            child: Icon(
              EcampusIcons.icons8_search,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => SearchSchedule(
                    context: context,
                  ),
                ),
              );
            },
          )
        ],
        ContentSchedule(
          key: scheduleKey,
          context: context,
          getIndex: getPageIndex,
          ecampus: widget.ecampus,
        ),
        EcampusIcons.icons8_schedule,
        '????????????????????',
      ),
      CustomBottomNavItem(
        "????????????????",
        CupertinoButton(
          child: Icon(
            EcampusIcons.icons8_doughnut_chart,
            color: primaryColor,
          ),
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => StatisticsPage(
                  context: context,
                ),
              ),
            );
          },
        ),
        [
          CupertinoButton(
            onPressed: () {
              CacheSystem.invalidateAcademicYearsResponse();
              subjectsKey.currentState!.fillData();
            },
            child: Icon(
              EcampusIcons.icons8_restart,
              color: primaryColor,
            ),
          )
        ],
        ContentSubjects(
          key: subjectsKey,
          context: context,
          setElevation: setAppbarElevation,
          getIndex: getPageIndex,
          ecampus: widget.ecampus,
        ),
        EcampusIcons.icons8_books,
        '????????????????',
      ),
      CustomBottomNavItem(
        "??????????????",
        const SizedBox(),
        [
          CupertinoButton(
            child: Icon(
              EcampusIcons.icons8_notification,
              color: primaryColor,
            ),
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => NotificationsPage(
                    context: context,
                  ),
                ),
              );
            },
          )
        ],
        ContentServices(
            context: context,
            setElevation: setAppbarElevation,
            ecampus: widget.ecampus),
        EcampusIcons.icons8_circled_menu,
        '??????????????',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: bottomNavItems[pageIndex].leading,
        actions: bottomNavItems[pageIndex].actions,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            bottomNavItems[pageIndex].title != "eCampus" || true
                ? SizedBox(
                    width: double.infinity,
                    child: Text(
                      bottomNavItems[pageIndex].title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      // color: primaryColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SvgPicture.asset(
                        //   "images/lovestar_1.svg",
                        //   color: primaryColor,
                        //   width: 24,
                        // ),
                        Text(
                          "Limited 1 of 1",
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.titleLarge!.copyWith(
                                    fontFamily: "LimitedEditionFont",
                                    fontWeight: FontWeight.bold,
                                    color: primaryColor,
                                  ),
                        ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
      body: FadeIndexedStack(
        index: pageIndex,
        children: [
          bottomNavItems[0].content,
          bottomNavItems[1].content,
          bottomNavItems[2].content,
          bottomNavItems[3].content,
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: buildCustomBottomNavigaton(context, bottomNavItems),
      ),
    );
  }
}
