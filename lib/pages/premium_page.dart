import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/models/premium_options.dart';
import 'package:ecampus_ncfu/models/premium_picker_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';

class PremiumPage extends StatefulWidget {
  const PremiumPage({Key? key}) : super(key: key);

  @override
  State<PremiumPage> createState() => _PremiumPageState();
}

class _PremiumPageState extends State<PremiumPage> {
  bool checkBox1 = false;
  bool checkBox2 = false;
  int _value = 1;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: SafeArea(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 20,
                        ),
                        child: OnTapScaleAndFade(
                          onTap: () {
                            // To send the click data to the server
                            context.read<ApiCubit>().state.api.sendStat(
                                  "Cicked_back_btn",
                                  extra: "Premium page",
                                );

                            Navigator.of(context).pop();
                          },
                          child: Icon(
                            EcampusIcons.icons8_back,
                            size: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Lottie.asset(
                    "images/animations/premium-crown.json",
                    animate: true,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "eCampus Premium",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Text(
                      "Больше свободы и множество эксклюзивных функций с подпиской eCampus Premium",
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 13,
                          ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: PremiumPlan(
                          value: _value,
                          onValueChanged: (value) {
                            setState(() {
                              _value = value;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).cardColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 5,
                        ),
                        CrossListElement(
                          onPressed: () {
                            // To send the click data to the server
                            context.read<ApiCubit>().state.api.sendStat(
                                  "Clicked_no_captcha_btn",
                                  extra: "Premium page",
                                );
                          },
                          child: const PremOptions(
                            svgPath: "images/captcha.svg",
                            title: "No Captcha",
                            description:
                                "С премиум-подпиской в eCampus Premium забудьте о CAPTCHA, наслаждайтесь эксклюзивным удобством приложения.",
                          ),
                        ),
                        CrossListElement(
                          onPressed: () {
                            // To send the click data to the server
                            context.read<ApiCubit>().state.api.sendStat(
                                  "Teach_stats_btn",
                                  extra: "Premium page",
                                );
                          },
                          child: const PremOptions(
                            svgPath: "images/rating.svg",
                            title: "Статистика Учителей",
                            description:
                                "Вы получите доступ к рейтингам всех преподавателей.",
                          ),
                        ),
                        CrossListElement(
                          onPressed: () {
                            // To send the click data to the server
                            context.read<ApiCubit>().state.api.sendStat(
                                  "Real_time_notif_btn",
                                  extra: "Premium page",
                                );
                          },
                          child: const PremOptions(
                            title: "Уведомления в реальном времени",
                            svgPath: "images/notification.svg",
                            description:
                                "Получайте мгновенные уведомления в реальном времени и всегда оставайтесь в курсе актуальной информации.",
                          ),
                        ),
                        CrossListElement(
                          onPressed: () {
                            // To send the click data to the server
                            context.read<ApiCubit>().state.api.sendStat(
                                  "Clicked_user_avatar_btn",
                                  extra: "Premium page",
                                );
                          },
                          child: const PremOptions(
                            title: "Пользовательский аватар",
                            description:
                                "Установите в качестве аватарки любое изображение или вещь и подчеркните свою индивидуальность.",
                          ),
                        ),
                        CrossListElement(
                          onPressed: () {
                            // To send the click data to the server
                            context.read<ApiCubit>().state.api.sendStat(
                                  "Clicked_crown_btn",
                                  extra: "Premium page",
                                );
                          },
                          child: const PremOptions(
                            title: "Уникальная Иконка Профиля",
                            svgPath: "images/crown.svg",
                            description:
                                "С премиум-подпиской вы получите уникальную иконку профиля, выделяющую ваш особый статус :)",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 70,
                  )
                ],
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 5,
          right: 0,
          left: 0,
          child: Container(
            padding: const EdgeInsets.only(
              top: 10,
              bottom: 5,
              left: 5,
              right: 5,
            ),
            height: 70,
            color: Theme.of(context).cardColor,
            child: CrossButton(
              backgroundColor: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(12),
              height: 50,
              child: Text(
                _value == 1
                    ? "Купить премиум подписку за 3,00\$ в месяц"
                    : "Купить премиум подписку за 5,00\$ в месяц",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              onPressed: () {
                // To send the click data to the server
                context.read<ApiCubit>().state.api.sendStat(
                      "Clicked_buy_premium_btn",
                      extra: "Premium page",
                    );
              },
            ),
          ),
        ),
      ],
    );
  }
}
