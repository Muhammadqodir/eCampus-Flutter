import 'package:ecampus_ncfu/tech_info/system_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrossTextField extends StatelessWidget {
  const CrossTextField({
    Key? key,
    this.autocorrect = true,
    this.backgroundColor = Colors.white,
    this.borderRadius = BorderRadius.zero,
    this.enableSuggestions = true,
    this.height,
    this.width,
    this.keyboardType,
    this.obscureText = false,
    this.padding = const EdgeInsets.all(6.0),
    this.placeholder,
    this.prefix,
    this.suffix,
    this.controller,
    this.textInputAction,
    this.textStyle,
  }) : super(key: key);

  final TextEditingController? controller;
  final TextStyle? textStyle;
  final bool obscureText, enableSuggestions, autocorrect;
  final BorderRadius borderRadius;
  final Color backgroundColor;
  final String? placeholder;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final EdgeInsetsGeometry padding;
  final Widget? prefix;
  final Widget? suffix;
  final double? width, height;

  @override
  Widget build(BuildContext context) {
    print(SystemInfo().isIos);
    return SizedBox(
      width: width,
      height: height,
      child: SystemInfo().isIos
          ? CupertinoTextField(
              style: textStyle,
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: borderRadius,
              ),
              padding: padding,
              placeholder: placeholder,
              obscureText: obscureText,
              enableSuggestions: enableSuggestions,
              controller: controller,
              autocorrect: autocorrect,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              prefix: prefix,
            )
          : TextField(
              style: textStyle,
              obscureText: obscureText,
              enableSuggestions: enableSuggestions,
              controller: controller,
              autocorrect: autocorrect,
              keyboardType: keyboardType,
              textInputAction: textInputAction,
              decoration: InputDecoration(
                prefixIcon: prefix,
                contentPadding: padding,
                fillColor: backgroundColor,
                filled: true,
                focusedBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: backgroundColor,
                    width: 0,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: borderRadius,
                  borderSide: BorderSide(
                    color: backgroundColor,
                    width: 0,
                  ),
                ),
                hintText: placeholder,
                hintStyle: textStyle,
                labelStyle: textStyle,
              ),
            ),
    );
  }
}
