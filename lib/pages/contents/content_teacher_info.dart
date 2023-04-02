import 'dart:convert';
import 'dart:developer';
import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_activity_indicator.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/inc/teacher_rating.dart';
import 'package:ecampus_ncfu/models/teacher_review.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
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
  int initTeach = 0;
  int initExam = 0;
  int initHumor = 0;
  String userId = "undefined";

  List<TeacherReview> reviewsList = [];

  @override
  void initState() {
    CacheSystem.getUserId().then((value) {
      userId = value;
    });
    getTeacherInfo();
    super.initState();
  }

  void getTeacherInfo() async {
    setState(() {
      loading = true;
    });
    if (await isOnline()) {
      final ref = widget.database.ref("teachers/${widget.teacherId}");
      DataSnapshot snapshot = await ref.get();
      if (snapshot.exists) {
        String dataJson = jsonEncode(snapshot.value);
        Map<String, dynamic> data = jsonDecode(dataJson);
        loading = false;
        notFound = false;
        info = data["moreInfo"];
        picUrl = data["picUrl"];
        contactInfo = data["contactInfo"];
        employeePageUrl = data["employeePageUrl"];
        try {
          Map<String, dynamic> reviewsRaw = data["rating"]["reviews"];
          for (Map<String, dynamic> key in reviewsRaw.values) {
            TeacherReview review = TeacherReview(
              key["id"],
              key["author"],
              key["date"],
              key["message"],
              key["target"],
            );
            try {
              String authorName =  (await widget.database.ref("usersData/${key["author"]}/fullName").get()).value as String;
              review.setAuthorName(authorName);
            } catch (e) {
              log(e.toString());
              review.setAuthorName("Аноним");
            }
            List<dynamic> likes = key["likes"];
            for (String like in likes) {
              review.addLike(like);
            }
            reviewsList.add(review);
          }
        } catch (e) {
          log("Error on getting reviews$e");
        }
        try {
          humorRating = data["rating"]["humorRating"];
          for (String key in humorRating.keys) {
            if (key == userId) {
              initHumor = humorRating[key].toInt();
            }
          }
        } catch (e) {
          log("Can not load HumorRating for ${data["fullName"]}");
        }
        try {
          examRating = data["rating"]["examRating"];
          for (String key in examRating.keys) {
            if (key == userId) {
              initExam = examRating[key].toInt();
            }
          }
        } catch (e) {
          log("Can not load ExamRating for ${data["fullName"]}");
        }
        try {
          teachSkills = data["rating"]["teachSkills"];
          for (String key in teachSkills.keys) {
            if (key == userId) {
              initTeach = teachSkills[key].toInt();
            }
          }
        } catch (e) {
          log("Can not load TeachSlikks for ${data["fullName"]}");
        }
        setState(() {});
      } else {
        setState(() {
          loading = false;
          notFound = true;
        });
      }
    } else {
      Navigator.pop(context);
      showOfflineDialog(context);
    }
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

  void setRating(String rType, int value) async {
    String userId = await CacheSystem.getUserId();
    DatabaseReference tRef = widget.database
        .ref("teachers/${widget.teacherId}/rating/$rType/$userId");
    log("teachers/${widget.teacherId}/rating/$rType/$userId");
    tRef.set(value);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: loading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Image.network(
                                picUrl,
                                width: 150,
                              ),
                              const SizedBox(
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
                          const SizedBox(
                            height: 8,
                          ),
                          TeacherRating(
                            examRating: getExamRating(),
                            humorRating: getHumorRating(),
                            teachSkills: getTeachSkills(),
                            initExam: initExam,
                            initHumor: initHumor,
                            initTeach: initTeach,
                            setRating: setRating,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          if (reviewsList.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Text("Отзывы студентов:", style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold)),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: reviewsList
                                      .map((e) => e.getView(context))
                                      .toList(),
                                ),
                                const SizedBox(
                                  height: 8,
                                ),
                              ],
                            ),
                          CrossButton(
                            wight: double.infinity,
                            onPressed: () async {
                              log(widget.teacherId.toString());
                              // String url = employeePageUrl;
                              // if (await canLaunchUrlString(url)) {
                              //   await launchUrlString(url);
                              // } else {
                              //   throw "Could not launch $url";
                              // }
                            },
                            backgroundColor: Theme.of(context).primaryColor,
                            child: const Text("Подробнее"),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Image.asset("images/not_found.png"),
                  ),
                ),
    );
  }
}
