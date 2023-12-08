// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dashed_circle/dashed_circle.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ecampus_ncfu/models/story_model.dart';
import 'package:ecampus_ncfu/themes.dart';

class StoryCircle extends StatefulWidget {
  const StoryCircle({
    Key? key,
    required this.child,
    required this.isExist,
    required this.isActive,
    required this.models,
  }) : super(key: key);

  final Widget child;
  final bool isExist;
  final bool isActive;
  final List<StoryModel> models;

  @override
  State<StoryCircle> createState() => _StoryCircleState();
}

class _StoryCircleState extends State<StoryCircle>
    with SingleTickerProviderStateMixin {
  late Animation gap;
  late Animation<double> base;
  late Animation<double> reverse;
  late AnimationController controller;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 3));
    base = CurvedAnimation(parent: controller, curve: Curves.easeInBack);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 10, end: 2.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(const Duration(seconds: 1))
        .then((value) => controller.forward());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.isExist
        ? RotationTransition(
            turns: base,
            child: DashedCircle(
              gapSize: gap.value,
              dashes: 15,
              color: widget.isActive ? primaryColor : grayColor,
              child: RotationTransition(
                turns: reverse,
                child: Padding(
                    padding: const EdgeInsets.all(5.0), child: widget.child),
              ),
            ),
          )
        : widget.child;
  }
}
