import 'package:ecampus_ncfu/cache_system.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class ContentSubjects extends StatefulWidget {
  const ContentSubjects(
      {Key? key, required this.context, required this.setElevation})
      : super(key: key);

  final BuildContext context;
  final Function setElevation;

  @override
  State<ContentSubjects> createState() => _ContentSubjectsState();
}

class _ContentSubjectsState extends State<ContentSubjects> {
  late eCampus ecampus;
  bool loading = true;
  List<AcademicYearsModel> academicYears = [];
  int selectedCourseIndex = 0;
  int selectedTermId = 0;
  List<SubjectModel> subjectModels = [];
  double elevation = 0;
  int studentId = 0;
  int kodCart = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      ecampus = eCampus(value.getString("token") ?? "undefined");
      isOnline().then((isOnline) {
        if (isOnline) {
          fillData();
        } else {
          showOfflineDialog(context);
        }
      });
    });
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
    ecampus.isActualToken().then((isActualToken) {
      if (isActualToken) {
        ecampus.getAcademicYears().then((value) {
          if (value.isSuccess) {
            CacheSystem.saveAcademicYearsResponse(value);
            setState(() {
              academicYears = value.models!;
              selectedCourseIndex = value.getCurrentCourse();
              selectedTermId = value.getCurrentTerm();
              subjectModels = value.currentSubjects!.models;
              studentId = value.studentId!;
              loading = false;
            });
          } else {
            showAlertDialog(context, "Ошибка", value.error);
          }
        });
      } else {
        ecampus.getCaptcha().then((captcha) {
          showCapchaDialog(context, captcha, ecampus, () {
            getFreshData();
          });
        });
      }
    });
  }

  void getsubjects(int termId) {
    setState(() {
      loading = true;
    });
    ecampus.isActualToken().then((isActualToken) {
      if (isActualToken) {
        ecampus.getSubjects(studentId, termId).then((value) {
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
        ecampus.getCaptcha().then((captcha) {
          showCapchaDialog(context, captcha, ecampus, () {
            getsubjects(termId);
          });
        });
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
                Text(
                  "Загрузка...",
                  style: Theme.of(context).textTheme.bodyMedium,
                )
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
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: Column(children: [
                    Row(
                      children: academicYears
                          .map(
                            (element) => Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(4),
                                child: CrossButton(
                                  onPressed: () {
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
                                padding: EdgeInsets.all(4),
                                child: CrossButton(
                                  onPressed: () {
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
                                  backgroundColor: element.id == selectedTermId
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
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
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
                                padding: EdgeInsets.all(12),
                                child: element.getView(context),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ]),
                ),
              ],
            ),
          );
  }
}
