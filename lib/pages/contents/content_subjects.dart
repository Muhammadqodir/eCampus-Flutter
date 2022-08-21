import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
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
  int selectedCourse = 0;

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
        : Column(
            children: [
              Column(children: [
                Row(
                  children: academicYears
                      .map(
                        (element) => Text(
                          element.name,
                        ),
                      )
                      .toList(),
                ),
                Row(
                  children: academicYears[selectedCourse]
                      .termModels
                      .map((element) => Text(element.name))
                      .toList(),
                )
              ]),
            ],
          );
  }
}
