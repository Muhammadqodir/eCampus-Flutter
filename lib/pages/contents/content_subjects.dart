import 'package:flutter/material.dart';

class ContentSubjects extends StatefulWidget {
  const ContentSubjects({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<ContentSubjects> createState() => _ContentSubjectsState();
}

class _ContentSubjectsState extends State<ContentSubjects> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text(
      "Предметы",
      style: Theme.of(context).textTheme.bodyMedium,
    ));
  }
}
