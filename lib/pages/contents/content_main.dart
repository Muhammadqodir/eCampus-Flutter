import 'dart:developer';
import 'dart:typed_data';

import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/bottom_nav.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/inc/main_info.dart';
import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/models/schedule_models.dart';
import 'package:ecampus_ncfu/models/teacher_model.dart';
import 'package:ecampus_ncfu/pages/login_page.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/gui_utils.dart';
import '../../utils/utils.dart';

class ContentMain extends StatefulWidget {
  const ContentMain(
      {Key? key, required this.context, required this.setElevation})
      : super(key: key);

  final BuildContext context;
  final Function setElevation;

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
    SharedPreferences.getInstance().then((value) {
      ecampus = eCampus(value.getString("token") ?? "undefined");
      update();
    });
  }

  void update({bool showCaptchaDialog = false, bool useCache = true}) {
    CacheSystem.isActualCache().then(
      (value) {
        if (value && useCache) {
          getCacheData();
        } else {
          setState(() {
            userName = null;
            ratingModel = null;
            userPic = null;
            isUnActualToken = false;
          });
          ecampus.isActualToken().then((value) {
            if (value) {
              isUnActualToken = false;
              getFreshData();
            } else {
              if (showCaptchaDialog) {
                isOnline().then((isOnline) {
                  if (isOnline) {
                    ecampus.getCaptcha().then((captchaImage) {
                      showCapchaDialog(context, captchaImage, ecampus, update);
                    });
                    getCacheData();
                  } else {
                    showOfflineDialog(context);
                  }
                });
              } else {
                setState(() {
                  isUnActualToken = true;
                });
                getCacheData();
              }
            }
          });
        }
      },
    );
  }

  void getCacheData() async {
    CacheResult? scheduleCache = await CacheSystem.getCurrentSchedule();
    if (scheduleCache != null) {
      if (scheduleCache.value != null) {
        setState(() {
          schedule = (scheduleCache.value as ScheduleResponse).scheduleModels;
        });
      } else {
        log("update");
        update(useCache: false);
      }
    } else {
      setState(() {
        log("update");
        update(useCache: false);
      });
    }
    StudentCache studentCache = await CacheSystem.getStudentCache();
    setState(() {
      userName = studentCache.userName;
      userPic = studentCache.userPic;
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
    setState(() {
      userName = null;
      ratingModel = null;
      userPic = null;
    });
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
        print(ratingResponse.error);
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
                update(showCaptchaDialog: true);
              },
            ),
            SliverList(
              delegate: SliverChildListDelegate([
                Column(
                  children: <Widget>[
                    Column(
                      children: [
                        isUnActualToken
                            ? Container(
                                child: Text(
                                  "Данные могут быть неактуальными!",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .copyWith(color: Colors.red),
                                ),
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
                            : SizedBox(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CupertinoButton(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(12)),
                          disabledColor: Theme.of(context).dividerColor,
                          color: Theme.of(context).primaryColor,
                          child: Text(
                            "Электронный пропуск",
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          onPressed: () {
                            // SharedPreferences.getInstance().then((value) => {
                            //       value.setString("token", "invalid"),
                            //     });
                            log(ratingModel!.toJson().toString());
                          },
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12, right: 12),
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: const BoxDecoration(
                          color: Color(0xFFDDF1EF),
                          borderRadius: BorderRadius.all(
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
                            Column(
                              children: getLessonModels()
                                  .map(
                                    (e) => Column(
                                      children: [
                                        e.getView(context),
                                        getLessonModels().indexOf(e) !=
                                                getLessonModels().length - 1
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
