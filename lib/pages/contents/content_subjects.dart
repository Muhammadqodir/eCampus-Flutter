import 'package:ecampus_ncfu/cache_system.dart';
import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:ecampus_ncfu/pages/subject_details.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';

class ContentSubjects extends StatefulWidget {
  const ContentSubjects({
    Key? key,
    required this.context,
    required this.setElevation,
    required this.getIndex,
    required this.ecampus,
  }) : super(key: key);

  final BuildContext context;
  final Function setElevation;
  final Function getIndex;
  final eCampus ecampus;

  @override
  State<ContentSubjects> createState() => ContentSubjectsState();
}

class ContentSubjectsState extends State<ContentSubjects> {
  bool loading = true;
  List<AcademicYearsModel> academicYears = [];
  int selectedCourseIndex = 0;
  int selectedTermId = 0;
  List<SubjectModel> subjectModels = [];
  double elevation = 0;
  int studentId = 0;
  int kodCart = 0;
  bool isDataLoaded = true;

  @override
  void initState() {
    super.initState();
    isOnline().then((isOnline) {
      if (isOnline) {
        fillData();
      } else {
        showOfflineDialog(context);
      }
    });
  }

  void onPageActive() {
    if (!isDataLoaded) {
      SharedPreferences.getInstance().then((value) {
        widget.ecampus.setToken(value.getString("token") ?? 'undefined');
        fillData();
      });
    }
  }

  void fillData() {
    setState(() {
      loading = true;
    });
    CacheSystem.getAcademicYearsResponse().then((value) {
      if (value != null) {
        if (value.isActualCache()) {
          getCacheData();
        } else {
          getFreshData();
        }
      } else {
        getFreshData();
      }
    });
  }

  void getCacheData() {
    CacheSystem.getAcademicYearsResponse().then((value) {
      AcademicYearsResponse response = value!.value;
      if (response.isSuccess) {
        CacheSystem.saveAcademicYearsResponse(response);
        setState(() {
          academicYears = response.models!;
          selectedCourseIndex = response.getCurrentCourse();
          selectedTermId = response.getCurrentTerm();
          subjectModels = response.currentSubjects!.models;
          studentId = response.studentId ?? 0;
          kodCart = response.kodCart ?? 0;
          loading = false;
        });
      } else {
        showAlertDialog(context, "Ошибка", response.error);
      }
    });
  }

  void getFreshData() {
    widget.ecampus.isActualToken().then((isActualToken) {
      if (isActualToken) {
        widget.ecampus.getAcademicYears().then((value) {
          if (value.isSuccess) {
            CacheSystem.saveAcademicYearsResponse(value);
            setState(() {
              academicYears = value.models!;
              selectedCourseIndex = value.getCurrentCourse();
              selectedTermId = value.getCurrentTerm();
              subjectModels = value.currentSubjects!.models;
              studentId = value.studentId!;
              loading = false;
              isDataLoaded = true;
            });
          } else {
            showAlertDialog(context, "Ошибка", value.error);
          }
        });
      } else {
        if (widget.getIndex() == 2) {
          widget.ecampus.getCaptcha().then((captcha) {
            showCapchaDialog(context, captcha, widget.ecampus, () {
              getFreshData();
            });
          });
        } else {
          isDataLoaded = false;
        }
      }
    });
  }

  void getsubjects(int termId) {
    setState(() {
      loading = true;
    });
    widget.ecampus.isActualToken().then((isActualToken) {
      if (isActualToken) {
        widget.ecampus.getSubjects(studentId, termId).then((value) {
          if (value.isSuccess) {
            setState(() {
              selectedTermId = termId;
              subjectModels = value.models;
              loading = false;
            });
          } else {
            showAlertDialog(context, "Ошибка", value.error);
          }
        });
      } else {
        if (widget.getIndex() == 2) {
          widget.ecampus.getCaptcha().then((captcha) {
            showCapchaDialog(context, captcha, widget.ecampus, () {
              getsubjects(termId);
            });
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const CupertinoActivityIndicator(
                  radius: 12,
                ),
                const SizedBox(
                  height: 8,
                ),
                Shimmer.fromColors(
                  period: const Duration(milliseconds: 1000),
                  baseColor: Theme.of(context).secondaryHeaderColor,
                  highlightColor: Colors.grey[400]!,
                  child: Text(
                    "Загрузка...",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                if (!context.watch<ApiCubit>().state.isPremium)
                  const AppodealBanner(
                    adSize: AppodealBannerSize.BANNER,
                  ),
              ],
            ),
          )
        : NotificationListener<ScrollUpdateNotification>(
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
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(
                    children: [
                      Row(
                        children: academicYears
                            .map(
                              (element) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: CrossButton(
                                    onPressed: () {
                                      // To send the click data to the server
                                      context
                                          .read<ApiCubit>()
                                          .state
                                          .api
                                          .sendStat(
                                            "Pushed_courses_btn",
                                            extra: "Subjects page",
                                          );

                                      setState(() {
                                        selectedCourseIndex =
                                            academicYears.indexOf(element);
                                      });
                                    },
                                    backgroundColor: selectedCourseIndex ==
                                            academicYears.indexOf(element)
                                        ? Theme.of(context).primaryColor
                                        : Theme.of(context)
                                            .scaffoldBackgroundColor,
                                    child: Text(
                                      "${element.name} ${element.kursTypeName}",
                                      style: selectedCourseIndex ==
                                              academicYears.indexOf(element)
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)
                                          : Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Row(
                        children: academicYears[selectedCourseIndex]
                            .termModels
                            .map(
                              (element) => Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(4),
                                  child: CrossButton(
                                    onPressed: () {
                                      // To send the click data to the server
                                      context
                                          .read<ApiCubit>()
                                          .state
                                          .api
                                          .sendStat(
                                            "Pushed_semester_btn",
                                            extra: "Subjects page",
                                          );

                                      if (element.id != selectedTermId) {
                                        isOnline().then((isOnline) => {
                                              if (isOnline)
                                                {
                                                  getsubjects(element.id),
                                                }
                                              else
                                                {
                                                  showOfflineDialog(context),
                                                }
                                            });
                                      }
                                    },
                                    backgroundColor:
                                        element.id == selectedTermId
                                            ? Theme.of(context).primaryColor
                                            : Theme.of(context)
                                                .scaffoldBackgroundColor,
                                    child: Text(
                                      "${element.name} ${element.termTypeName}",
                                      style: element.id == selectedTermId
                                          ? Theme.of(context)
                                              .textTheme
                                              .headlineMedium
                                              ?.copyWith(
                                                  fontWeight: FontWeight.bold)
                                          : Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      Column(
                        children: subjectModels
                            .map(
                              (element) => CrossListElement(
                                onPressed: () {
                                  // To send the data to the server
                                  context.read<ApiCubit>().state.api.sendStat(
                                        "Pushed_subj_deta_btn",
                                        extra: "Subjects page",
                                      );

                                  Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => SubjectDetailsPage(
                                        context: context,
                                        subName: element.name,
                                        studentId: studentId,
                                        kodCart: kodCart,
                                        lessonTypes: element.lessonTypes,
                                      ),
                                    ),
                                  );
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(12),
                                  child: element.getView(context),
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
