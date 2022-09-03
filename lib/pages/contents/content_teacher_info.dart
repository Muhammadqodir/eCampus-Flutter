import 'dart:convert';
import 'dart:developer';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_activity_indicator.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../utils/utils.dart';

class ContentTeacherInfo extends StatefulWidget {
  const ContentTeacherInfo(
      {Key? key,
      required this.context,
      required this.teacherId,
      required this.database,
      required this.ecampus,
      required this.teacherName})
      : super(key: key);

  final BuildContext context;
  final String teacherName;
  final int teacherId;
  final eCampus ecampus;
  final FirebaseDatabase database;

  @override
  State<ContentTeacherInfo> createState() => _ContentTeacherInfoState();
}

class _ContentTeacherInfoState extends State<ContentTeacherInfo> {
  bool loading = true;
  bool notFound = false;

  String info = "";
  String contactInfo = "";
  String employeePageUrl = "";
  String picUrl = "";
  Map<String, dynamic> humorRating = {};
  Map<String, dynamic> examRating = {};
  Map<String, dynamic> teachSkills = {};

  @override
  void initState() {
    getTeacherInfo();
    super.initState();
  }

  void getTeacherInfo() {
    setState(() {
      loading = true;
    });
    isOnline().then((isOnline) {
      if (isOnline) {
        final ref = widget.database.ref("teachers/${widget.teacherId}");
        ref.get().then((snapshot) {
          if (snapshot.exists) {
            String dataJson = jsonEncode(snapshot.value);
            Map<String, dynamic> data = jsonDecode(dataJson);
            setState(() {
              loading = false;
              notFound = false;
              info = data["moreInfo"];
              picUrl = data["picUrl"];
              contactInfo = data["contactInfo"];
              employeePageUrl = data["employeePageUrl"];
              try {
                humorRating = data["rating"]["humorRating"];
                examRating = data["rating"]["examRating"];
                teachSkills = data["rating"]["teachSkills"];
              } catch (e) {}
            });
          } else {
            setState(() {
              loading = false;
              notFound = true;
            });
          }
        });
      } else {
        Navigator.pop(context);
        showOfflineDialog(context);
      }
    });
  }

  double getHumorRating() {
    if (humorRating.isEmpty) {
      return 0;
    } else {
      int sum = 0;
      for (int rating in humorRating.values) {
        sum += rating;
      }
      return sum / humorRating.length;
    }
  }

  double getTeachSkills() {
    if (teachSkills.isEmpty) {
      return 0;
    } else {
      int sum = 0;
      for (int rating in teachSkills.values) {
        sum += rating;
      }
      return sum / teachSkills.length;
    }
  }

  double getExamRating() {
    if (examRating.isEmpty) {
      return 0;
    } else {
      int sum = 0;
      for (int rating in examRating.values) {
        sum += rating;
      }
      return sum / examRating.length;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: loading
            ? Column(
                children: [
                  CrossActivityIndicator(
                    radius: 12,
                    color: Theme.of(context).dividerColor,
                  ),
                  Text(
                    "Загрузка...",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              )
            : !notFound
                ? ListView(
                  physics: ClampingScrollPhysics(),
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(
                                  picUrl,
                                  width: 150,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Expanded(
                                  child: Column(
                                    children: [
                                      Text(
                                        widget.teacherName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium!
                                            .copyWith(
                                                fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        contactInfo,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              info,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Способность донести материал:",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Column(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      glow: false,
                                      itemCount: 5,
                                      itemSize: 28,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    Text(
                                      getTeachSkills() > 0
                                          ? "${getTeachSkills().toStringAsFixed(2)} из 5"
                                          : "Без рейтинга",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Сложность сдачи экзамена:",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Column(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      glow: false,
                                      itemCount: 5,
                                      itemSize: 28,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    Text(
                                      getExamRating() > 0
                                          ? "${getExamRating().toStringAsFixed(2)} из 5"
                                          : "Без рейтинга",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "Чувство юмора:",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ),
                                Column(
                                  children: [
                                    RatingBar.builder(
                                      initialRating: 0,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      glow: false,
                                      itemCount: 5,
                                      itemSize: 28,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        size: 12,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    ),
                                    Text(
                                      getHumorRating() > 0
                                          ? "${getHumorRating().toStringAsFixed(2)} из 5"
                                          : "Без рейтинга",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(
                                              fontWeight: FontWeight.bold),
                                    )
                                  ],
                                )
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            CrossButton(
                              wight: double.infinity,
                              onPressed: () async {
                                String url = employeePageUrl;
                                if (await canLaunchUrlString(url)) {
                                  await launchUrlString(url);
                                } else {
                                  throw "Could not launch $url";
                                }
                              },
                              backgroundColor: Theme.of(context).primaryColor,
                              child: Text("Подробнее"),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : Text("Not found"));
  }
}
