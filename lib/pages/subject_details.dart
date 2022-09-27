import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/ecampus_master/responses.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:ecampus_ncfu/pages/contents/content_lesson_type.dart';
import 'package:ecampus_ncfu/utils/dialogs.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubjectDetailsPage extends StatefulWidget {
  const SubjectDetailsPage({
    Key? key,
    required this.context,
    required this.subName,
    required this.studentId,
    required this.kodCart,
    required this.lessonTypes,
  }) : super(key: key);

  final BuildContext context;
  final int studentId;
  final int kodCart;
  final List<LessonTypesModel> lessonTypes;
  final String subName;

  @override
  State<SubjectDetailsPage> createState() => _SubjectDetailsPageState();
}

class _SubjectDetailsPageState extends State<SubjectDetailsPage> {
  _SubjectDetailsPageState();
  double elevation = 0;
  bool loading = true;
  late eCampus ecampus;
  List<LessonItemsResponse> models = [];

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      ecampus = eCampus(value.getString("token") ?? "undefined");
      update();
    });
  }

  void update({bool showCaptchaDialog = false}) {
    isOnline().then((isOnline) {
      setState(() {
        loading = true;
        models = [];
      });
      if (isOnline) {
        ecampus.getAllLessonItems(widget.studentId, widget.lessonTypes).then(
          (value) {
            setState(() {
              loading = false;
              models = value;
            });
          },
        );
      } else {
        showOfflineDialog(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: widget.lessonTypes.length,
      child: Scaffold(
        appBar: AppBar(
            elevation: 0.5,
            leading: CupertinoButton(
              onPressed: (() {
                Navigator.pop(context);
              }),
              child: const Icon(EcampusIcons.icons8_back),
            ),
            title: Text(
              widget.subName,
              overflow: TextOverflow.fade,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            bottom: TabBar(
              isScrollable: true,
              tabs: widget.lessonTypes
                  .map(
                    (e) => Tab(
                      child: Text(
                        e.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  )
                  .toList(),
            )),
        body: TabBarView(
            physics: const BouncingScrollPhysics(),
            children: widget.lessonTypes
                .map((e) => ContentLessonType(
                      context: context,
                      subName: widget.subName,
                      title: e.name,
                      kodCart: widget.kodCart,
                      kodPr: e.kodPr,
                      lessonTypeId: e.id,
                      studentId: widget.studentId,
                      models: loading
                          ? []
                          : models[widget.lessonTypes.indexOf(e)].models,
                    ))
                .toList()),
      ),
    );
  }
}
