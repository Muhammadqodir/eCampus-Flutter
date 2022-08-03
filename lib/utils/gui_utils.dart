import 'package:flutter/material.dart';

Widget TextSkeleton({double height = 20, double width = double.infinity, Color color = Colors.black26}){
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

Widget CircleSkeleton({double radius = 20, Color color = Colors.black26}){
  return SizedBox(
          width: radius*2,
          height: radius*2,
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
          color: _buttonHeldDown ? Theme.of(context).dividerColor.withAlpha(100) : Theme.of(context).scaffoldBackgroundColor,
          duration: Duration(milliseconds: 200),
          child: widget.child,
        ),
      ),
    );
  }
}