import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/rating_model.dart';
import 'package:ecampus_ncfu/pages/contents/content_teacher_info.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TeachersPage extends StatefulWidget {
  const TeachersPage({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;

  @override
  State<TeachersPage> createState() => _TeachersPageState();
}

class _TeachersPageState extends State<TeachersPage> {
  eCampus? ecampus;
  List<RatingModel>? models;
  double elevation = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sPref) => {
          ecampus = eCampus(sPref.getString("token")!),
        });
    paginator = _getNewPaginator("");
  }

  String _getFaculty(String desc) {
    int indexStart = desc.indexOf("Институт / Факультет:");
    if (indexStart < 0) {
      return "";
    }
    return desc.substring(indexStart + "Институт / Факультет:\n".length);
  }

  Widget? paginator;
  Timer? _debounce;
  _onSearchChanged(String value) {
    paginator = null;
    setState(() {});

    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 1000), () {
      if (value.length >= 2) {
        paginator = _getNewPaginator(value);
        setState(() {});
      } else {
        paginator = _getNewPaginator("");
        setState(() {});
      }
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _debounce?.cancel();
  }

  BuildContext? scafoldContext;

  @override
  Widget build(BuildContext context) {
    scafoldContext = context;
    return Scaffold(
        appBar: AppBar(
          leading: CupertinoButton(
            onPressed: (() {
              Navigator.pop(context);
            }),
            child: const Icon(EcampusIcons.icons8_back),
          ),
          titleSpacing: 0,
          // actions: [
          //   CupertinoButton(
          //     onPressed: (){},
          //     child: const Icon(EcampusIcons.icons8_search),
          //   )
          // ],
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          elevation: elevation,
          title: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CupertinoSearchTextField(
              autofocus: true,
              placeholder: "Поиск",
              style: Theme.of(context).textTheme.bodyMedium,
              onChanged: _onSearchChanged,
            ),
          ),
        ),
        body: paginator ?? Container());
  }

  Widget _getNewPaginator(String serach) {
    return PaginateFirestore(
      isLive: true,
      itemBuilder: (ctx, documentSnapshots, index) {
        final data = documentSnapshots[index].data() as Map?;
        if (data == null) {
          return const SizedBox();
        }
        return CrossListElement(
          onPressed: () {
            showCupertinoModalBottomSheet(
              context: context,
              builder: (context) => ContentTeacherInfo(
                context: context,
                ecampus: ecampus!,
                database: FirebaseDatabase.instance,
                teacherId: data["teacherId"],
                teacherName: data["fullName"],
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 6,
              horizontal: 12,
            ),
            child: Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 50,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: Image.network(
                        data["picUrl"],
                        errorBuilder: (context, url, error) => Icon(
                          Icons.error,
                          color: CustomColors.error,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data["fullName"],
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium!
                            .copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _getFaculty(data["moreInfo"]),
                        style: Theme.of(context).textTheme.bodySmall,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
      query: FirebaseFirestore.instance
          .collection('teachers')
          .orderBy('fullName')
          .startAt([serach.capitalize()]),
      itemBuilderType: PaginateBuilderType.listView,
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (length == 0) {
      return this;
    }
    return "${this[0].toUpperCase()}${this.substring(1).toLowerCase()}";
  }
}
