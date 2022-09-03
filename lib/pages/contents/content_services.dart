import 'dart:developer';
import 'dart:typed_data';

import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/bottom_nav.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/inc/main_info.dart';
import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/inc/service_item.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/models/teacher_model.dart';
import 'package:ecampus_ncfu/pages/login_page.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/gui_utils.dart';
import '../../utils/utils.dart';

class ContentServices extends StatefulWidget {
  const ContentServices(
      {Key? key, required this.context, required this.setElevation})
      : super(key: key);

  final BuildContext context;
  final Function setElevation;

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
            setState(() {
              elevation = 0.5;
              widget.setElevation(elevation);
            });
          }
          if (notification.metrics.pixels <= 0 && elevation != 0) {
            setState(() {
              elevation = 0;
              widget.setElevation(elevation);
            });
          }
          return true;
        },
        child: ListView(
          children: [
            CrossListElement(
              onPressed: () {},
              child: ServiceItem(
                icon: EcampusIcons.icons8_doughnut_chart,
                backgroundColor: CustomColors.colorPalette[0],
                title: "Статистика",
                subTitle: "Расчитаем количество откритых и закритых КТ, \"Н\"ок и т.д.",
              ),
            ),
            CrossListElement(
              onPressed: () {},
              child: ServiceItem(
                icon: EcampusIcons.icons8_leaderboard,
                backgroundColor: CustomColors.colorPalette[1],
                title: "Рейтинг",
                subTitle: "Список ваших одногрупников и их рейтинг",
              ),
            ),
            CrossListElement(
              onPressed: () {},
              child: ServiceItem(
                icon: EcampusIcons.icons8_teacher,
                backgroundColor: CustomColors.colorPalette[2],
                title: "Мои преподаватели",
                subTitle: "Узнайте характер учителя, прочитайте отзивы студентов.",
              ),
            ),
            CrossListElement(
              onPressed: () {},
              child: ServiceItem(
                icon: EcampusIcons.icons8_wi_fi,
                backgroundColor: CustomColors.colorPalette[1],
                title: "Wi-Fi",
                subTitle: "Сброс пароля от университетского Wi-Fi.",
              ),
            ),
            CrossListElement(
              onPressed: () {},
              child: ServiceItem(
                icon: EcampusIcons.icons8_map,
                backgroundColor: CustomColors.colorPalette[3],
                title: "Карта корпусов",
                subTitle: "Геолокация корпусов, общежитий, мед. пункта и т.д",
              ),
            ),
            CrossListElement(
              onPressed: () {},
              enabled: false,
              child: ServiceItem(
                commingSoon: true,
                icon: EcampusIcons.record_book,
                backgroundColor: CustomColors.colorPalette[4],
                title: "Зачётная книжка",
                subTitle: "Электронная зачетная книжка",
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
                subTitle: "Здесь Вы можете подать заявку на получение услуги студенческого офиса онлайн",
              ),
            )
          ],
        ));
  }
}
