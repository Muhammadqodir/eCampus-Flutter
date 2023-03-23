import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/inc/service_item.dart';
import 'package:ecampus_ncfu/pages/map_page.dart';
import 'package:ecampus_ncfu/pages/my_teachers_page.dart';
import 'package:ecampus_ncfu/pages/rating_page.dart';
import 'package:ecampus_ncfu/pages/record_book_page.dart';
import 'package:ecampus_ncfu/pages/statistics_page.dart';
import 'package:ecampus_ncfu/pages/wifi_page.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class ContentServices extends StatefulWidget {
  const ContentServices(
      {Key? key,
      required this.context,
      required this.setElevation,
      required this.ecampus})
      : super(key: key);

  final BuildContext context;
  final Function setElevation;
  final eCampus ecampus;

  @override
  State<ContentServices> createState() => _ContentServicesState();
}

class _ContentServicesState extends State<ContentServices> {
  double elevation = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollUpdateNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels > 0 && elevation == 0) {
          elevation = 0.5;
          widget.setElevation(elevation);
        }
        if (notification.metrics.pixels <= 0 && elevation != 0) {
          elevation = 0;
          widget.setElevation(elevation);
        }
        return true;
      },
      child: ListView(
        physics: const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics(),
        ),
        children: [
          CrossListElement(
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
            child: ServiceItem(
              icon: EcampusIcons.icons8_doughnut_chart,
              backgroundColor: CustomColors.colorPalette[0],
              title: "Статистика",
              subTitle:
                  "Расчитаем количество открытых и закрытых КТ, \"Н\"ок и т.д.",
            ),
          ),
          CrossListElement(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => RatingPage(
                    context: context,
                  ),
                ),
              );
            },
            child: ServiceItem(
              icon: EcampusIcons.icons8_notification,
              backgroundColor: CustomColors.colorPalette[1],
              title: "Уведомления",
              subTitle: "Список ваших одногруппников и их рейтинг",
            ),
          ),
          CrossListElement(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => RatingPage(
                    context: context,
                  ),
                ),
              );
            },
            child: ServiceItem(
              icon: EcampusIcons.icons8_leaderboard,
              backgroundColor: CustomColors.colorPalette[1],
              title: "Рейтинг",
              subTitle: "Список ваших одногруппников и их рейтинг",
            ),
          ),
          CrossListElement(
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
            child: ServiceItem(
              icon: EcampusIcons.icons8_teacher,
              backgroundColor: CustomColors.colorPalette[2],
              title: "Мои преподаватели",
              subTitle:
                  "Прочитайте характеристику учителей и отзывы студентов.",
            ),
          ),
          CrossListElement(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => MapPage(
                    context: context,
                  ),
                ),
              );
            },
            child: ServiceItem(
              icon: EcampusIcons.icons8_map,
              backgroundColor: CustomColors.colorPalette[3],
              title: "Карта корпусов",
              subTitle: "Геолокация корпусов, общежитий, мед. пункта и т.д",
            ),
          ),
          CrossListElement(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => RecordBookPage(
                    context: context,
                    ecampus: widget.ecampus,
                  ),
                ),
              );
            },
            enabled: true,
            child: ServiceItem(
              commingSoon: false,
              icon: EcampusIcons.record_book,
              backgroundColor: CustomColors.colorPalette[4],
              title: "Зачётная книжка",
              subTitle: "Электронная зачетная книжка",
            ),
          ),
          CrossListElement(
            onPressed: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (context) => WifiPage(
                    ecampus: widget.ecampus,
                  ),
                ),
              );
            },
            enabled: true,
            child: ServiceItem(
              commingSoon: false,
              icon: EcampusIcons.icons8_wi_fi,
              backgroundColor: CustomColors.colorPalette[1],
              title: "Wi-Fi",
              subTitle: "Сброс пароля от университетского Wi-Fi.",
            ),
          ),
          CrossListElement(
            onPressed: () {},
            enabled: false,
            child: ServiceItem(
              commingSoon: true,
              icon: EcampusIcons.ncfu_new,
              backgroundColor: CustomColors.colorPalette[4],
              title: "Студ. офис СКФУ",
              subTitle:
                  "Здесь Вы можете подать заявку на получение услуги студенческого офиса онлайн",
            ),
          )
        ],
      ),
    );
  }
}
