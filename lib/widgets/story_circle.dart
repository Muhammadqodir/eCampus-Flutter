import 'package:dashed_circle/dashed_circle.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StoryCircle extends StatefulWidget {
  const StoryCircle({super.key, required this.child});
  final Widget child;

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
        AnimationController(vsync: this, duration: Duration(seconds: 3));
    base = CurvedAnimation(
        parent: controller, curve: Curves.easeInBack);
    reverse = Tween<double>(begin: 0.0, end: -1.0).animate(base);
    gap = Tween<double>(begin: 10, end: 2.0).animate(base)
      ..addListener(() {
        setState(() {});
      });
    Future.delayed(Duration(seconds: 1)).then((value) => controller.forward());
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: base,
      child: DashedCircle(
        gapSize: gap.value,
        dashes: 15,
        color: primaryColor,
        child: RotationTransition(
          turns: reverse,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: widget.child
          ),
        ),
      ),
    );
  }
}
