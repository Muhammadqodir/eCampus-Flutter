import 'dart:developer';
import 'dart:typed_data';
import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/main_info.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/models/schedule_models.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import '../../utils/utils.dart';

class ContentMain extends StatefulWidget {
  const ContentMain(
      {Key? key, required this.context, required this.setElevation, required this.update})
      : super(key: key);

  final BuildContext context;
  final Function setElevation;
  final Function() update;

  @override
  State<ContentMain> createState() => _ContentMainState();
}

class _ContentMainState extends State<ContentMain> {
  late eCampus ecampus;
  String? userName;
  RatingModel? ratingModel;
  Uint8List? userPic;
  bool isUnActualToken = false;
  double elevation = 0;

  @override
  void initState() {
    super.initState();
    update();
  }

  void update({isSwipeRefresh = false}) async {
    String? token = (await SharedPreferences.getInstance()).getString("token");
    ecampus = eCampus(token ?? "undefined");
    setState(() {
      userName = null;
      ratingModel = null;
      userPic = null;
      isUnActualToken = false;
    });
    getCacheData();
    if (await ecampus.isActualToken()) {
      setState(() {
        isUnActualToken = false;
      });
      getFreshData();
    } else {
      if (!(await CacheSystem.isActualCache())) {
        setState(() {
          isUnActualToken = true;
        });
      }
      if (isSwipeRefresh) {
        showCapchaDialog(context, await ecampus.getCaptcha(), ecampus, () {
          update();
        });
      }
    }
    widget.update();
  }

  void getCacheData() async {
    CacheResult? scheduleCache = await CacheSystem.getCurrentSchedule();
    if (scheduleCache != null) {
      if (scheduleCache.value != null) {
        setState(() {
          schedule = (scheduleCache.value as ScheduleResponse).scheduleModels;
        });
      }
    }
    StudentCache studentCache = await CacheSystem.getStudentCache();
    setState(() {
      if (studentCache.userName != "undefined") {
        userName = studentCache.userName;
      }
      if (studentCache.userPic != null) {
        userPic = studentCache.userPic;
      }
      if (studentCache.ratingModel.fullName != "undefined") {
        ratingModel = studentCache.ratingModel;
        rating = true;
      } else {
        rating = false;
      }
    });
  }

  bool rating = true;
  void getFreshData() {
    ecampus.getUserName().then((vUserName) {
      CacheSystem.saveUserName(vUserName);
      setState(() {
        userName = vUserName;
      });
    });
    ecampus.getUserPic().then((vUserPic) {
      CacheSystem.saveUserPic(vUserPic);
      setState(
        () {
          userPic = vUserPic;
        },
      );
    });
    ecampus.getCurrentSchedule().then((scheduleResponse) {
      if (scheduleResponse.isSuccess) {
        CacheSystem.saveCurrentScheduleWeek(scheduleResponse);
        setState(() {
          schedule = scheduleResponse.scheduleModels;
        });
      }
    });
    ecampus.getRating().then((ratingResponse) {
      if (ratingResponse.isSuccess) {
        CacheSystem.saveRating(getMyRating(ratingResponse.items));
        setState(() {
          rating = true;
          ratingModel = getMyRating(ratingResponse.items);
        });
      } else {
        log(ratingResponse.error);
        setState(() {
          rating = false;
        });
      }
    });
  }

  List<ScheduleModel> schedule = [];

  List<ScheduleLessonsModel> getLessonModels() {
    for (ScheduleModel model in schedule) {
      if (model.date.weekday == DateTime.now().weekday) {
        return model.lessons;
      }
    }
    return [];
  }

  void review() async {
    final InAppReview inAppReview = InAppReview.instance;


    // inAppReview.openStoreListing(appStoreId: '1644613830');
    if (await inAppReview.isAvailable()) {
        inAppReview.requestReview();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: NotificationListener<ScrollUpdateNotification>(
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
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: [
            CupertinoSliverRefreshControl(
              onRefresh: () async {
                update(isSwipeRefresh: true);
              },
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: <Widget>[
                    Column(
                      children: [
                        isUnActualToken
                            ? Text(
                                "Данные могут быть неактуальными!",
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.red),
                              )
                            : const SizedBox(),
                        userPic != null
                            ? MainInfoView().getAvaterView(userPic!)
                            : MainInfoView().getAvaterViewSkeleton(context),
                        userName != null
                            ? MainInfoView().getUserNameView(context, userName!)
                            : MainInfoView().getUserNameViewSkeleton(context),
                        rating
                            ? ratingModel != null
                                ? MainInfoView().getRatingBarView(
                                    context,
                                    averageRating: ratingModel!.ball,
                                    groupRating: ratingModel!.ratGroup,
                                    instituteRating: ratingModel!.ratInst,
                                    studentsNumberInGroup:
                                        ratingModel!.maxPosGroup,
                                    studentsNumberInInstitute:
                                        ratingModel!.maxPosInst,
                                  )
                                : MainInfoView()
                                    .getRatingBarViewSkeleton(context)
                            : const SizedBox(),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 12, left: 12, right: 12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CupertinoButton(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          disabledColor: Theme.of(context).dividerColor,
                          color: Theme.of(context).primaryColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Icon(EcampusIcons.icons8_doughnut_chart),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                "Статистика",
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium!
                                    .copyWith(fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          onPressed: () {
                            // if (!isUnActualToken) {
                            //   Navigator.push(
                            //     context,
                            //     CupertinoPageRoute(
                            //       builder: (context) => StatisticsPage(
                            //         context: context,
                            //       ),
                            //     ),
                            //   );
                            // }else{
                            //   update();
                            // }

                            review();
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    const AppodealBanner(
                      adSize: AppodealBannerSize.BANNER,
                      placement: "default",
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Theme.of(context).secondaryHeaderColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        width: double.infinity,
                        child: Column(
                          children: [
                            Text(
                              "Расписание",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            getLessonModels().isNotEmpty
                                ? Column(
                                    children: getLessonModels()
                                        .map(
                                          (e) => Column(
                                            children: [
                                              e.getView(context),
                                              getLessonModels().indexOf(e) !=
                                                      getLessonModels().length -
                                                          1
                                                  ? const Divider(
                                                      indent: 12,
                                                      endIndent: 12,
                                                    )
                                                  : const SizedBox()
                                            ],
                                          ),
                                        )
                                        .toList(),
                                  )
                                : Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Image.asset(
                                          "images/empty.png",
                                          height: 100,
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
                                  )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
