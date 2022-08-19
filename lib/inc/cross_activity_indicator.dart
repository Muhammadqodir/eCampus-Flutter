import 'package:ecampus_ncfu/tech_info/system_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrossActivityIndicator extends StatelessWidget {
  const CrossActivityIndicator({
    Key? key,
    this.color = Colors.white,
    this.radius = 0,
  }) : super(key: key);

  final double radius;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SystemInfo().isIos
        ? CupertinoActivityIndicator(
            radius: radius,
            color: color,
          )
        : SizedBox(
            height: radius * 2,
            width: radius * 2,
            child: CircularProgressIndicator(
              color: color,
            ),
          );
  }
}
