import 'package:ecampus_ncfu/inc/ontap_scale.dart';
import 'package:ecampus_ncfu/utils/gui_utils.dart';
import 'package:ecampus_ncfu/utils/system_info.dart';
import 'package:flutter/material.dart';

class CrossListElement extends StatelessWidget {
  const CrossListElement({
    Key? key,
    required this.onPressed,
    required this.child,
    this.enabled = true,
  }) : super(key: key);

  final Widget child;
  final bool enabled;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SystemInfo().isIos
            ? CupertinoInkWell(
                onPressed: onPressed,
                child: OnTapScaleAndFade(
                  onTap: onPressed!,
                  child: Opacity(
                    opacity: enabled ? 1 : 0.6,
                    child: child,
                  ),
                ),
              )
            : InkWell(
                onTap: onPressed,
                child: OnTapScaleAndFade(
                  onTap: onPressed!,
                  child: Opacity(
                    opacity: enabled ? 1 : 0.6,
                    child: child,
                  ),
                ),
              ),
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).dividerColor,
          ),
          height: 0.6,
        )
      ],
    );
  }
}
