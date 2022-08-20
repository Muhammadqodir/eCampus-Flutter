import 'package:ecampus_ncfu/utils/system_info.dart';
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
            title: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            content: Text(
              content,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
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
  final String child;

  @override
  Widget build(BuildContext context) {
    return SystemInfo().isIos
        ? CupertinoDialogAction(
            isDestructiveAction: isDestructiveAction,
            onPressed: onPressed,
            child: Text(child),
          )
        : TextButton(
            onPressed: onPressed,
            child: Text(
              child,
              style: TextStyle(
                color: isDestructiveAction ? Colors.red : Colors.blue,
                fontSize: 18,
              ),
            ),
          );
  }
}
