import 'package:ecampus_ncfu/cubit/api_cubit.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/models/subject_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

class ContentLessonType extends StatefulWidget {
  const ContentLessonType({
    Key? key,
    required this.context,
    required this.subName,
    required this.title,
    required this.kodCart,
    required this.kodPr,
    required this.lessonTypeId,
    required this.studentId,
    required this.models,
  }) : super(key: key);

  final BuildContext context;
  final String title;
  final int studentId;
  final int lessonTypeId;
  final int kodPr;
  final String subName;
  final int kodCart;
  final List<LessonItemModel> models;

  @override
  State<ContentLessonType> createState() => _ContentLessonTypeState();
}

class _ContentLessonTypeState extends State<ContentLessonType> {
  @override
  Widget build(BuildContext context) {
    return widget.models.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Shimmer.fromColors(
                period: const Duration(milliseconds: 1000),
                baseColor: Theme.of(context).secondaryHeaderColor,
                highlightColor: Colors.grey[400]!,
                child: Text(
                  "Загрузка...",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          )
        : ListView(
            children: widget.models
                .map(
                  (e) => CrossListElement(
                    onPressed: () {
                      // To send the click data to the server
                      context.read<ApiCubit>().state.api.sendStat(
                            "Pushed_cross_list_elmnt_btn",
                            extra: "Content lesson type page",
                          );
                    },
                    child: e.getView(context),
                  ),
                )
                .toList(),
          );
  }
}
