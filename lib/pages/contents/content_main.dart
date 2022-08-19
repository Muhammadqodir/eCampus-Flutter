import 'dart:typed_data';

import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/main_info.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../utils/utils.dart';

class ContentMain extends StatefulWidget {
  const ContentMain({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<ContentMain> createState() => _ContentMainState();
}

class _ContentMainState extends State<ContentMain> {
  late ECampus ecampus;
  String? userName;
  RatingModel? ratingModel;
  Uint8List? userPic;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => {
          ecampus = ECampus(
            value.getString("token") ?? "undefined",
          ),
          update(),
        });
  }

  void update() {
    setState(() {
      userName = null;
      ratingModel = null;
      userPic = null;
    });
    ecampus.getUserName().then((vUserName) => {
          setState(
            () => {userName = vUserName},
          ),
        });
    ecampus.getUserPic().then((vUserPic) => {
          setState(
            () => {userPic = vUserPic},
          )
        });
    ecampus.getRating().then((ratingResponse) => {
          if (ratingResponse.isSuccess)
            {
              setState(
                () => {
                  ratingModel = getMyRating(
                    ratingResponse.items,
                  )
                },
              )
            }
          else
            {
              print(
                ratingResponse.error,
              )
            }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CustomScrollView(
        slivers: [
          CupertinoSliverRefreshControl(
            onRefresh: () async {
              update();
            },
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                Column(
                  children: <Widget>[
                    Column(
                      children: [
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
                                studentsNumberInInstitute:
                                    ratingModel!.maxPosInst,
                              )
                            : MainInfoView().getRatingBarViewSkeleton(context)
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: CrossButton(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12),
                          ),
                          disabledColor: Theme.of(context).dividerColor,
                          backgroundColor: Theme.of(context).primaryColor,
                          child: Text(
                            "Электронный пропуск",
                            style: Theme.of(context).textTheme.headlineMedium,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 12,
                        right: 12,
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color(0xFFDDF1EF),
                          borderRadius: BorderRadius.all(
                            Radius.circular(12),
                          ),
                        ),
                        width: double.infinity,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            children: [
                              Text(
                                "Расписание",
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              const SizedBox(
                                height: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
