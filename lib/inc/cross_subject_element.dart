import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dart:math';

import '../ecampus_icons.dart';
import 'cross_button.dart';

class CrossSubjectElement extends StatelessWidget {
  const CrossSubjectElement({
    Key? key,
    required this.name,
    required this.id,
    required this.locked,
    required this.parentId,
    required this.subType,
    required this.termsForAtt,
    required this.CurrentRating,
    required this.HasInstruction,
    required this.HasLectures,
    required this.HasUMK,
    required this.IsConfirmDocumentExists,
    required this.MaxRating,
    this.heigth,
    this.width = double.infinity,
    this.radius = Radius.zero,
    this.backgroundColor = Colors.white,
    this.borderWidth = 0,
  }) : super(key: key);

  final String name, termsForAtt, subType;
  final int MaxRating, parentId, id;
  final bool locked, IsConfirmDocumentExists, HasLectures, HasInstruction, HasUMK;
  final double? width, heigth;
  final double borderWidth, CurrentRating;
  final Radius radius;
  final Color backgroundColor;
  //ArrayList<LessonTypesModel> lessonTypes;

  @override
  Widget build(BuildContext context) {
    Map<String, Color> subColors = {
      "Зачет": Colors.green,
      "Дифференцированный зачет": Colors.orangeAccent,
      "Экзамен": Colors.red,
    };

    return SizedBox(
      width: width,
      height: heigth,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(radius),
              color: backgroundColor,
              border: Border.all(
                width: borderWidth,
                color: backgroundColor,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: subColors[termsForAtt] ?? Colors.green,
                          border: Border.all(
                            width: 5,
                            color: subColors[termsForAtt] ?? Colors.green,
                          ),
                        ),
                        child: Text(
                          termsForAtt,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CrossButton(
                        height: 35,
                        width: 100,
                        padding: const EdgeInsets.all(4),
                        borderRadius: BorderRadius.circular(12),
                        backgroundColor: Theme.of(context).primaryColor,
                        onPressed: () {},
                        child: Row(
                          children: [
                            Icon(
                              EcampusIcons.icons8_download,
                              color: Theme.of(context).canvasColor,
                            ),
                            Text(
                              "Загрузки",
                              style: Theme.of(context).textTheme.headlineMedium,
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircularPercentIndicator(
                      radius: 40.0,
                      animation: true,
                      animationDuration: 400,
                      lineWidth: 5.0,
                      backgroundWidth: 3.0,
                      percent: min(CurrentRating / MaxRating.toDouble(), 1),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "$CurrentRating",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "из",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            "$MaxRating",
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      circularStrokeCap: CircularStrokeCap.butt,
                      backgroundColor: Theme.of(context).disabledColor,
                      progressColor: Theme.of(context).primaryColor,
                    ),
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
