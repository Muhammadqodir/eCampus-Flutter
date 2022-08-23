import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/system_info.dart';
import 'package:flutter/material.dart';

class CrossListElement extends StatelessWidget {
  const CrossListElement({
    Key? key,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final Widget child;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SystemInfo().isIos
            ? CupertinoInkWell(
                onPressed: onPressed,
                child: OnTapScaleAndFade(
                  child: child,
                  onTap: () {},
                ),
              )
            : InkWell(
                onTap: onPressed,
                child: OnTapScaleAndFade(
                  child: child,
                  onTap: () {},
                ),
              ),
        const Divider(
          height: 1,
        )
      ],
    );
  }
}
