import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';

void showConfirmDialog(
      BuildContext context, String title, String msg, void Function() confirmAction) {
    showCupertinoDialog<void>(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(msg),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: false,
            onPressed: confirmAction,
            child: Text("Подтверить"),
          ),
          CupertinoDialogAction(
            /// This parameter indicates the action would perform
            /// a destructive action such as deletion, and turns
            /// the action's text color to red.
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Отменить"),
          )
        ],
      ),
    );
  }
