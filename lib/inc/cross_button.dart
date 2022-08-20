import 'package:ecampus_ncfu/utils/system_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrossButton extends StatelessWidget {
  const CrossButton({
    Key? key,
    this.text = "",
    required this.onPressed,
    this.backgroundColor = Colors.white,
    this.disabledColor = const Color.fromARGB(255, 71, 71, 71),
    required this.child,
    this.height,
    this.wight,
    this.padding = EdgeInsets.zero,
    this.borderRadius = BorderRadius.zero,
  }) : super(key: key);

  final EdgeInsetsGeometry? padding;
  final double? wight, height;
  final Widget child;
  final String text;
  final void Function()? onPressed;
  final Color backgroundColor;
  final BorderRadius borderRadius;
  final Color disabledColor;

//refresh swipe

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: wight,
      child: SystemInfo().isIos
          ? CupertinoButton(
              padding: padding,
              color: backgroundColor,
              borderRadius: borderRadius,
              onPressed: onPressed,
              disabledColor: disabledColor,
              child: child,
            )
          : ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                primary: backgroundColor,
                onSurface: disabledColor,
                padding: padding,
                shape: RoundedRectangleBorder(
                  borderRadius: borderRadius,
                ),
              ),
              child: child,
            ),
    );
  }
}
