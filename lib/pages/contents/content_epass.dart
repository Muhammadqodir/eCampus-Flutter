import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/inc/cross_list_element.dart';
import 'package:ecampus_ncfu/inc/service_item.dart';
import 'package:ecampus_ncfu/pages/map_page.dart';
import 'package:ecampus_ncfu/pages/my_teachers_page.dart';
import 'package:ecampus_ncfu/pages/rating_page.dart';
import 'package:ecampus_ncfu/pages/statistics_page.dart';
import 'package:ecampus_ncfu/utils/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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