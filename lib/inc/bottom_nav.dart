import 'dart:convert';

import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../ecampus_icons.dart';

class CustomBottomNavItem {
  String title = "undefined";
  Widget leading = Container();
  List<Widget> actions = [];
  Widget content = Container();
  IconData icon = Icons.stop;
  String label = "item";

  CustomBottomNavItem(this.title, this.leading, this.actions, this.content,
      this.icon, this.label);
}