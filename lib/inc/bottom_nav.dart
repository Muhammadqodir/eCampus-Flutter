import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomBottomNavItem {
  String title = "undefined";
  Widget leading = Container();
  List<Widget> actions = [];
  StatefulWidget content;
  IconData icon = Icons.stop;
  String label = "item";

  CustomBottomNavItem(this.title, this.leading, this.actions, this.content,
      this.icon, this.label);
}