import 'package:ecampus_ncfu/tech_info/system_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CrossDialog extends StatelessWidget {
  const CrossDialog({
    Key? key,
    required this.title,
    required this.actions,
    required this.content,
  }) : super(key: key);

  final String title;
  final String content;
  final List<Widget> actions;

  @override
  Widget build(BuildContext context) {
    return SystemInfo().isIos
        ? CupertinoAlertDialog(
            title: Text(title),
            content: Text(content),
            actions: actions,
          )
        : AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: Text(title),
            content: Text(content),
            actions: actions,
          );
  }
}

class CrossDialogAction extends StatelessWidget {
  const CrossDialogAction({
    Key? key,
    this.isDestructiveAction = false,
    required this.onPressed,
    required this.child,
  }) : super(key: key);

  final bool isDestructiveAction;
  final void Function() onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SystemInfo().isIos
        ? CupertinoDialogAction(
            isDestructiveAction: isDestructiveAction,
            onPressed: onPressed,
            child: child,
          )
        : ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              alignment: Alignment.center,
              backgroundColor: MaterialStateProperty.all<Color>(
                isDestructiveAction ? Colors.red : Colors.blue,
              ),
            ),
            child: child,
          );
  }
}
