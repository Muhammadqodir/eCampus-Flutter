import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ContentSubjects extends StatefulWidget {
  const ContentSubjects({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<ContentSubjects> createState() => _ContentSubjectsState();
}

class _ContentSubjectsState extends State<ContentSubjects> {
  late eCampus ecampus;
  bool loading = true;
  List<AcademicYearsModel> academicYears = [];
  int selectedCourse = 3;
  List<SubjectModel> subjectModels = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => {
          ecampus = eCampus(value.getString("token") ?? "undefined"),
          isOnline().then((isOnline) => {
                getData(),
              }),
        });
  }

  void getData() {
    ecampus.isActualToken().then((isActualToken) => {
          if (isActualToken)
            {
              ecampus.getAcademicYears().then((value) => {
                    if (value.isSuccess)
                      {
                        setState(
                          () => {
                            academicYears = value.models!,
                            selectedCourse = value.getCurrentCourse(),
                            subjectModels = value.currentSubjects!.models,
                            loading = false,
                          },
                        )
                      }
                    else
                      {
                        showAlertDialog(context, "Ошибка", value.error),
                      }
                  }),
            }
          else
            {
              ecampus.getCaptcha().then((captcha) => {
                    showCapchaDialog(context, captcha, ecampus, () {
                      getData();
                    }),
                  }),
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
        : ListView(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 4),
                child: Column(children: [
                  Row(
                    children: academicYears
                        .map(
                          (element) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: CrossButton(
                                onPressed: () {},
                                backgroundColor: element.isCurrent
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                child: Text(
                                  "${element.name} ${element.kursTypeName}",
                                  style: element.isCurrent
                                      ? Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                      : Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Row(
                    children: academicYears[selectedCourse]
                        .termModels
                        .map(
                          (element) => Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(4),
                              child: CrossButton(
                                onPressed: () {},
                                backgroundColor: element.isCurrent
                                    ? Theme.of(context).primaryColor
                                    : Theme.of(context).scaffoldBackgroundColor,
                                child: Text(
                                  "${element.name} ${element.termTypeName}",
                                  style: element.isCurrent
                                      ? Theme.of(context)
                                          .textTheme
                                          .headlineMedium
                                      : Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  Text("Size: " + subjectModels.length.toString()),
                  Column(
                    children: subjectModels
                        .map(
                          (element) => element.getView(context),
                        )
                        .toList(),
                  ),
                ]),
              ),
            ],
          );
  }
}
