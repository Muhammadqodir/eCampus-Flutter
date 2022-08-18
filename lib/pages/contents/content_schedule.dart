import 'package:flutter/material.dart';

class ContentSchedule extends StatefulWidget {
  const ContentSchedule({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<ContentSchedule> createState() => _ContentScheduleState();
}

class _ContentScheduleState extends State<ContentSchedule> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Рассписание",
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
