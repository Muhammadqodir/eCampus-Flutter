import 'dart:typed_data';

import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/bottom_nav.dart';
import 'package:ecampus_ncfu/inc/main_info.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/pages/login_page.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/gui_utils.dart';
import '../../utils/utils.dart';

class ContentMain extends StatefulWidget {
  const ContentMain({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<ContentMain> createState() => _ContentMainState();
}

class _ContentMainState extends State<ContentMain> {
  late eCampus ecampus;
  String? userName;
  RatingModel? ratingModel;
  Uint8List? userPic;
  bool isUnActualToken = false;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) =>
        {ecampus = eCampus(value.getString("token") ?? "undefined"), update()});
  }

  void update({bool showCaptchaDialog = false}) {
    CacheSystem.isActualCache().then(
      (value) => {
        if (value)
          {
            getCacheData(),
          }
        else
          {
            setState(() {
              userName = null;
              ratingModel = null;
              userPic = null;
              isUnActualToken = false;
            }),
            ecampus.isActualToken().then((value) => {
                  if (value)
                    {
                      isUnActualToken = false,
                      getFreshData(),
                    }
                  else
                    {
                      if (showCaptchaDialog)
                        {
                          ecampus.getCaptcha().then((captchaImage) => {
                                showCapchaDialog(context, captchaImage, ecampus)
                              })
                        }
                      else
                        {
                          setState(() => {
                            isUnActualToken = true
                          },),
                          getCacheData(),
                        }
                    }
                })
          }
      },
    );
  }

  void getCacheData() {
    CacheSystem.getStudentCache().then((value) => {
          setState(
            () => {
              userName = value.userName,
              userPic = value.userPic,
              ratingModel = value.ratingModel
            },
          )
        });
  }

  void getFreshData() {
    setState(() {
      userName = null;
      ratingModel = null;
      userPic = null;
    });
    ecampus.getUserName().then((vUserName) => {
          CacheSystem.saveUserName(vUserName),
          setState(
            () => {userName = vUserName},
          ),
        });
    ecampus.getUserPic().then((vUserPic) => {
          CacheSystem.saveUserPic(vUserPic),
          setState(
            () => {userPic = vUserPic},
          )
        });
    ecampus.getRating().then((ratingResponse) => {
          if (ratingResponse.isSuccess)
            {
              CacheSystem.saveRating(getMyRating(ratingResponse.items)),
              setState(
                () => {ratingModel = getMyRating(ratingResponse.items)},
              )
            }
          else
            {print(ratingResponse.error)}
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CustomScrollView(
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
                  ratingModel != null
                      ? MainInfoView().getRatingBarView(
                          context,
                          averageRating: ratingModel!.ball,
                          groupRating: ratingModel!.ratGroup,
                          instituteRating: ratingModel!.ratInst,
                          studentsNumberInGroup: ratingModel!.maxPosGroup,
                          studentsNumberInInstitute: ratingModel!.maxPosInst,
                        )
                      : MainInfoView().getRatingBarViewSkeleton(context)
                ],
              ),
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: CupertinoButton(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
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
                            SharedPreferences.getInstance().then((value) => {
                              value.setString("token", "invalid"),
                            });
                          }))),
              Padding(
                padding: const EdgeInsets.only(left: 12, right: 12),
                child: Container(
                  decoration: const BoxDecoration(
                      color: Color(0xFFDDF1EF),
                      borderRadius: BorderRadius.all(Radius.circular(12))),
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(children: [
                      Text(
                        "Расписание",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 12,
                      ),
                    ]),
                  ),
                ),
              )
            ],
          ),
        ]))
      ],
    ));
  }
}
