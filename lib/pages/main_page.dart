import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/bottom_nav.dart';
import 'package:ecampus_ncfu/inc/fade_indexed_stack.dart';
import 'package:ecampus_ncfu/models/version.dart';
import 'package:ecampus_ncfu/pages/contents/content_main.dart';
import 'package:ecampus_ncfu/pages/contents/content_schedule.dart';
import 'package:ecampus_ncfu/pages/contents/content_services.dart';
import 'package:ecampus_ncfu/pages/contents/content_subjects.dart';
import 'package:ecampus_ncfu/pages/login_page.dart';
import 'package:ecampus_ncfu/pages/my_teachers_page.dart';
import 'package:ecampus_ncfu/pages/notifications_page.dart';
import 'package:ecampus_ncfu/pages/premium_page.dart';
import 'package:ecampus_ncfu/pages/search_schedule_page.dart';
import 'package:ecampus_ncfu/pages/statistics_page.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

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

  late eCampus ecampus;

  int getPageIndex() {
    return pageIndex;
  }

  void startUp() async {
    ecampus = context.read<ApiCubit>().state.api;
    if (await isOnline()) {
      isActialToken = await ecampus.isActualToken();
      if (isActialToken) {
        notification_count = await ecampus.getNotificationSize();
      }
      print("Checking version");
      versionCheck();
    }
  }

  @override
  void initState() {
    content = ContentMain(
      context: context,
      update: update,
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
    startUp();
    super.initState();
  }

  void update() async {
    if (await isOnline()) {
      isActialToken = await ecampus.isActualToken();
      if (isActialToken) {
        notification_count = await ecampus.getNotificationSize();
      }
    }
  }

  int localVersion = 1;
  void versionCheck() async {
    ApiResponse<AppVersion> lastVerson = await ecampus.getLastVersion();
    if (lastVerson.isSuccess) {
      print("LastVersion:" + lastVerson.data!.name);
      if (localVersion < lastVerson.data!.version) {
        showUpdateDialog(context, lastVerson.data!.name);
      }
    } else {
      print(lastVerson.message);
    }
  }

  void setAppbarElevation(double visibility) {
    setState(() {
      elevation = visibility;
    });
  }

  bool bottomNavShadow = true;

  Container buildCustomBottomNavigaton(
    BuildContext ctx,
    List<CustomBottomNavItem> items,
  ) {
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
                      // To sent the click data to the server
                      context.read<ApiCubit>().state.api.sendStat(
                            "Pushed_bottom_nav_bar_btn",
                            extra: "Main page",
                          );

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
            // To send to the server about the button response
            context.read<ApiCubit>().state.api.sendStat(
                  "Pushed_logout_btn",
                  extra: "Главная страница",
                );

            showConfirmDialog(
                context, "Выход из профиля", "Подтвердите действие", () {
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
          if (!context.watch<ApiCubit>().state.isPremium)
            CupertinoButton(
              child: Icon(
                EcampusIcons.icons8_buy_upgrade,
                color: primaryColor,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => const PremiumPage(),
                  ),
                );
                // To the send data to the server
                context.read<ApiCubit>().state.api.sendStat(
                      "Pushed_buy_upgrade_btn",
                      extra: "Главная страница",
                    );
              },
            ),
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
                    : const SizedBox(),
              ],
            ),
            onPressed: () {
              // To send the click data to the server
              context.read<ApiCubit>().state.api.sendStat(
                    "Action_notif_btn",
                    extra: "Главная страница",
                  );

              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          ),
        ],
        ContentMain(
          context: context,
          update: update,
          setElevation: setAppbarElevation,
        ),
        EcampusIcons.icons8_student_male_1,
        'Главная',
      ),
      CustomBottomNavItem(
        "Расписание",
        CupertinoButton(
          child: Icon(
            EcampusIcons.icons8_teacher,
            color: primaryColor,
          ),
          onPressed: () {
            // To send the click data to the server
            context.read<ApiCubit>().state.api.sendStat("Pushed_teachers_btn",
                extra: "Расписание (страница)");
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
              context.read<ApiCubit>().state.api.sendStat(
                    "Pushed_search_btn",
                    extra: "Расписание (страница)",
                  );
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
        ),
        EcampusIcons.icons8_schedule,
        'Расписание',
      ),
      CustomBottomNavItem(
        "Предметы",
        CupertinoButton(
          child: Icon(
            EcampusIcons.icons8_doughnut_chart,
            color: primaryColor,
          ),
          onPressed: () {
            // To send the click data to the server
            context.read<ApiCubit>().state.api.sendStat(
                  "Pushed_statistics_btn",
                  extra: "Bottom nav bar",
                );

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
          ecampus: ecampus,
        ),
        EcampusIcons.icons8_books,
        'Предметы',
      ),
      CustomBottomNavItem(
        "Сервисы",
        const SizedBox(),
        [
          CupertinoButton(
            child: Icon(
              EcampusIcons.icons8_notification,
              color: primaryColor,
            ),
            onPressed: () {
              // To send the click data to the server
              context.read<ApiCubit>().state.api.sendStat(
                    "Pushed_action_notif_btn",
                    extra: "Statistics page",
                  );

              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => const NotificationsPage(),
                ),
              );
            },
          )
        ],
        ContentServices(
          context: context,
          setElevation: setAppbarElevation,
          ecampus: ecampus,
        ),
        EcampusIcons.icons8_circled_menu,
        'Сервисы',
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        leading: bottomNavItems[pageIndex].leading,
        actions: bottomNavItems[pageIndex].actions,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: elevation,
        centerTitle: true,
        title: Text(
          bottomNavItems[pageIndex].title,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
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
