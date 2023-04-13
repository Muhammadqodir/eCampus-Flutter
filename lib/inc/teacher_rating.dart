import 'package:ecampus_ncfu/inc/user_ava_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class TeacherRating extends StatefulWidget {
  TeacherRating(
      {Key? key,
      required this.examRating,
      required this.humorRating,
      required this.teachSkills,
      required this.initExam,
      required this.initHumor,
      required this.initTeach,
      required this.setRating,
      required this.teachSkillsC,
      required this.examRatingC,
      required this.humorRatingC})
      : super(key: key);

  Function(String, int) setRating;
  int initTeach;
  int initExam;
  int initHumor;
  double teachSkills;
  double examRating;
  double humorRating;
  Map<String, dynamic> teachSkillsC;
  Map<String, dynamic> examRatingC;
  Map<String, dynamic> humorRatingC;

  @override
  State<TeacherRating> createState() => _TeacherRatingState();
}

class _TeacherRatingState extends State<TeacherRating> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                "Способность донести материал:",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Column(
              children: [
                RatingBar.builder(
                  initialRating: widget.initTeach.toDouble(),
                  minRating: 0,
                  direction: Axis.horizontal,
                  glow: false,
                  itemCount: 5,
                  itemSize: 28,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    size: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    widget.setRating("teachSkills", rating.toInt());
                  },
                ),
                Text(
                  widget.teachSkills > 0
                      ? "${widget.teachSkills.toStringAsFixed(2)} из 5 (${widget.examRatingC.length} оценок)"
                      : "Без рейтинга",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Column(
              children: [
                RatingBar.builder(
                  initialRating: widget.initExam.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  glow: false,
                  itemCount: 5,
                  itemSize: 28,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    size: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    widget.setRating("examRating", rating.toInt());
                  },
                ),
                Text(
                  widget.examRating > 0
                      ? "${widget.examRating.toStringAsFixed(2)} из 5 (${widget.examRatingC.length} оценок)"
                      : "Без рейтинга",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  "1* - Сложно, 5* - Легко",
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10),
                ),
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
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            Column(
              children: [
                RatingBar.builder(
                  initialRating: widget.initHumor.toDouble(),
                  minRating: 1,
                  direction: Axis.horizontal,
                  glow: false,
                  itemCount: 5,
                  itemSize: 28,
                  itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    size: 12,
                    color: Theme.of(context).primaryColor,
                  ),
                  onRatingUpdate: (rating) {
                    widget.setRating("humorRating", rating.toInt());
                  },
                ),
                Text(
                  widget.humorRating > 0
                      ? "${widget.humorRating.toStringAsFixed(2)} из 5 (${widget.humorRatingC.length} оценок)"
                      : "Без рейтинга",
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }
}
