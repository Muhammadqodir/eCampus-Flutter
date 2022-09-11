import 'dart:typed_data';

import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/pages/main_page.dart';
import 'package:ecampus_ncfu/utils/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ecampus_icons.dart';

void showConfirmDialog(BuildContext context, String title, String msg,
    void Function() confirmAction) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(msg),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDestructiveAction: false,
          onPressed: confirmAction,
          child: const Text("Подтверить"),
        ),
        CupertinoDialogAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as deletion, and turns
          /// the action's text color to red.
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Отменить"),
        )
      ],
    ),
  );
}

void showOfflineDialog(BuildContext context) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text("Нет подключение"),
      content: const Text(
          "Не удалось подключится к серверу. Проверьте подключение  интернету и попробуйте снова."),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Окей"),
        ),
      ],
    ),
  );
}

void showCapchaDialog(BuildContext context, Uint8List captchaImage,
    eCampus ecampus, Function successCallBack) {
  TextEditingController captcha = TextEditingController();
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) => CupertinoAlertDialog(
      title: const Text("eCampus"),
      content: Center(
        child: Column(children: [
          Text(
            "Введите результат выражения:",
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(
            height: 3,
          ),
          Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(12)),
                    child: Image.memory(
                      captchaImage,
                      height: 42,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              CupertinoTextField(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black87),
                placeholderStyle: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: Colors.black87.withAlpha(100)),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12)),
                placeholder: "Результат капчи",
                obscureText: true,
                controller: captcha,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                prefix: const Padding(
                  padding: EdgeInsets.only(left: 8.0),
                  child: Icon(
                    EcampusIcons.icons8_captcha,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
        ]),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as deletion, and turns
          /// the action's text color to red.
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(dialogContext);
            showLoadingDialog(context);
            print(captcha.text);
            SharedPreferences.getInstance().then((value) => {
                  ecampus
                      .authenticate(value.getString("login") ?? "",
                          value.getString("password") ?? "", captcha.text)
                      .then((response) => {
                            if (response.isSuccess)
                              {
                                print(response.userName),
                                value
                                    .setString("token", response.cookie)
                                    .then((value) => {
                                          Navigator.pop(context),
                                          successCallBack(),
                                        }),
                              }
                            else
                              {
                                isOnline().then((isOnline) => {
                                      if (isOnline)
                                        {
                                          ecampus.getCaptcha().then((value) => {
                                                Navigator.pop(context),
                                                showCapchaDialog(context, value,
                                                    ecampus, successCallBack),
                                              }),
                                        }
                                      else
                                        {
                                          showOfflineDialog(context),
                                        }
                                    }),
                              }
                          })
                });
          },
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

void showLoadingDialog(BuildContext context) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text("Загрузка..."),
      content: Center(
        child: Column(children: const [
          SizedBox(
            height: 12,
          ),
          CupertinoActivityIndicator(
            radius: 12,
          )
        ]),
      ),
    ),
  );
}

void showAlertDialog(BuildContext context, String title, String message) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text("Окей"),
        ),
      ],
    ),
  );
}
