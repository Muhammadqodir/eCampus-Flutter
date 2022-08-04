import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget TextSkeleton(
    {double height = 20,
    double width = double.infinity,
    Color color = Colors.black26}) {
  return SizedBox(
      width: width,
      height: height,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.rectangle,
          borderRadius: const BorderRadius.all(Radius.circular(12)),
        ),
      ));
}

Widget CircleSkeleton({double radius = 20, Color color = Colors.black26}) {
  return SizedBox(
    width: radius * 2,
    height: radius * 2,
    child: Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    ),
  );
}

class CupertinoInkWell extends StatefulWidget {
  const CupertinoInkWell({
    Key? key,
    required this.child,
    required this.onPressed,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  bool get enabled => onPressed != null;

  @override
  State<CupertinoInkWell> createState() => _CupertinoInkWellState();
}

class _CupertinoInkWellState extends State<CupertinoInkWell> {
  bool _buttonHeldDown = false;

  void _handleTapDown(TapDownDetails event) {
    if (!_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = true;
      });
    }
  }

  void _handleTapUp(TapUpDetails event) {
    if (_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = false;
      });
    }
  }

  void _handleTapCancel() {
    if (_buttonHeldDown) {
      setState(() {
        _buttonHeldDown = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.enabled;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: enabled ? _handleTapDown : null,
      onTapUp: enabled ? _handleTapUp : null,
      onTapCancel: enabled ? _handleTapCancel : null,
      onTap: widget.onPressed,
      child: Semantics(
        button: true,
        child: AnimatedContainer(
          color: _buttonHeldDown
              ? Theme.of(context).dividerColor.withAlpha(100)
              : Theme.of(context).scaffoldBackgroundColor,
          duration: Duration(milliseconds: 200),
          child: widget.child,
        ),
      ),
    );
  }
}

Widget getNotificationSkeleton(BuildContext context) {
  return Shimmer.fromColors(
      baseColor: Colors.black26,
      highlightColor: Colors.black87,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(children: [
              CircleSkeleton(radius: 24),
              const SizedBox(
                width: 12,
              ),
              Flexible(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextSkeleton(
                      width: getWidthPercent(context, 60), height: 18),
                  const SizedBox(
                    height: 4,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextSkeleton(
                          width: getWidthPercent(context, 100), height: 12),
                      const SizedBox(
                        height: 2,
                      ),
                      TextSkeleton(
                          width: getWidthPercent(context, 40), height: 12),
                    ],
                  )
                ],
              )),
            ]),
          ),
          const Divider(
            height: 1,
          )
        ],
      ));
}
