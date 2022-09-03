import 'dart:developer';
import 'dart:typed_data';

import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/bottom_nav.dart';
import 'package:ecampus_ncfu/pages/contents/content_main.dart';
import 'package:ecampus_ncfu/pages/contents/content_schedule.dart';
import 'package:ecampus_ncfu/pages/contents/content_services.dart';
import 'package:ecampus_ncfu/pages/contents/content_subjects.dart';
import 'package:ecampus_ncfu/pages/login_page.dart';
import 'package:ecampus_ncfu/pages/my_teachers_page.dart';
import 'package:ecampus_ncfu/pages/notifications_page.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;
  Uint8List? captchaImage;
  double elevation = 0;
  StatefulWidget? content;

  @override
  void initState() {
    content = ContentMain(
      context: context,
      setElevation: setAppbarElevation,
    );
    super.initState();
  }

  void setAppbarElevation(double visibility) {
    setState(() {
      elevation = visibility;
    });
  }

  void updateSubjects() {}

  bool bottomNavShadow = true;

  Container buildCustomBottomNavigaton(
      BuildContext ctx, List<CustomBottomNavItem> items) {
    return Container(
      height: 61,
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: lightGray, offset: Offset(0, -0.5)),
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
                      content = item.content as StatefulWidget?;
                      elevation = 0;
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

  final GlobalKey<ContentSubjectsState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    List<CustomBottomNavItem> bottomNavItems = [
      CustomBottomNavItem(
        "eCampus",
        CupertinoButton(
          child: const Icon(EcampusIcons.icons8_logout_rounded_left),
          onPressed: () {
            showConfirmDialog(
                context, "Выход из профиля", "Подтвердите действие", () {
              CacheSystem.invalidateAllCache();
              SharedPreferences.getInstance().then((value) => {
                    value.setBool("isLogin", false),
                    value.setString("ecampus", "undefined"),
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
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
          CupertinoButton(
            child: const Icon(EcampusIcons.icons8_notification),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationsPage(
                    context: context,
                  ),
                ),
              );
            },
          )
        ],
        ContentMain(
          context: context,
          setElevation: setAppbarElevation,
        ),
        EcampusIcons.icons8_student_male_1,
        'Главная',
      ),
      CustomBottomNavItem(
        "Расписание",
        CupertinoButton(
          child: const Icon(EcampusIcons.icons8_teacher),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MyTeachersPage(
                  context: context,
                ),
              ),
            );
          },
        ),
        [
          CupertinoButton(
            child: const Icon(EcampusIcons.icons8_search),
            onPressed: () {
              //do somemthig
            },
          )
        ],
        ContentSchedule(context: context),
        EcampusIcons.icons8_schedule,
        'Расписание',
      ),
      CustomBottomNavItem(
        "Предметы",
        CupertinoButton(
          child: const Icon(EcampusIcons.icons8_doughnut_chart),
          onPressed: () {},
        ),
        [
          CupertinoButton(
            onPressed: () {
              CacheSystem.invalidateAcademicYearsResponse();
              _key.currentState!.fillData();
            },
            child: const Icon(EcampusIcons.icons8_restart),
          )
        ],
        ContentSubjects(
          key: _key,
          context: context,
          setElevation: setAppbarElevation,
        ),
        EcampusIcons.icons8_books,
        'Предметы',
      ),
      CustomBottomNavItem(
        "Сервисы",
        CupertinoButton(
          child: const Icon(EcampusIcons.icons8_buy_upgrade),
          onPressed: () {},
        ),
        [
          CupertinoButton(
            child: const Icon(EcampusIcons.icons8_notification),
            onPressed: () {
              //do somemthig
            },
          )
        ],
        ContentServices(
          context: context,
          setElevation: setAppbarElevation,
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
        title: Text(
          bottomNavItems[pageIndex].title,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: content,
      bottomNavigationBar: SafeArea(
        child: buildCustomBottomNavigaton(context, bottomNavItems),
      ),
    );
  }
}
