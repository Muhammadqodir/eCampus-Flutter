import 'package:flutter/material.dart';

class ContentEpass extends StatefulWidget {
  const ContentEpass({Key? key, required this.context}) : super(key: key);

  final BuildContext context;

  @override
  State<ContentEpass> createState() => _ContentEpassState();
}

class _ContentEpassState extends State<ContentEpass> {
  double elevation = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: 1,
      child: Container(
        child: Text(
          "eadfasdfasdfPass",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}
