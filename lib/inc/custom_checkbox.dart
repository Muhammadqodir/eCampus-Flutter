import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomCheckBox extends StatefulWidget {
  CustomCheckBox(
      {super.key,
      required this.value,
      this.checkedIcon = CupertinoIcons.check_mark,
      this.unCheckedIcon = CupertinoIcons.xmark,
      this.radius = 12,
      this.size = 24,
      required this.onChanged});

  bool value;
  final IconData checkedIcon;
  final IconData unCheckedIcon;
  double radius;
  final double size;
  final Function(bool) onChanged;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {

  @override
  Widget build(BuildContext context) {
    return OnTapScaleAndFade(
      lowerBound: 0.9,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.radius),
          color: primaryColor,
        ),
        padding: EdgeInsets.all(4),
        child: Icon(
          widget.value ? widget.checkedIcon : widget.unCheckedIcon,
          color: Colors.white,
          size: widget.size,
        ),
      ),
      onTap: () {
        widget.value = !widget.value;
        setState(() {
          
        });
        widget.onChanged(widget.value);
      },
    );
  }
}
