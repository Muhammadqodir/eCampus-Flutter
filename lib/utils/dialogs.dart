import 'dart:typed_data';

import 'package:ecampus_ncfu/inc/cross_dialog.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ecampus_icons.dart';

void showConfirmDialog(
  BuildContext context,
  String title,
  String msg,
  void Function() confirmAction,
) {
  showDialog<void>(
    context: context,
    builder: (BuildContext context) => CrossDialog(
      title: title,
      content: msg,
      actions: <CrossDialogAction>[
        CrossDialogAction(
          isDestructiveAction: false,
          onPressed: confirmAction,
          child: "Подтверить",
        ),
        CrossDialogAction(
          isDestructiveAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: "Отменить",
        )
      ],
    ),
  );
}

void showCapchaDialog(
  BuildContext context,
  Uint8List captchaImage,
  eCampus ecampus,
) {
  TextEditingController captcha = TextEditingController();
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext dialogContext) => CupertinoAlertDialog(
      title: const Text("eCampus"),
      content: Center(
        child: Column(
          children: [
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
                      borderRadius: const BorderRadius.all(
                        Radius.circular(12),
                      ),
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
                  style: Theme.of(context).textTheme.bodyMedium,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  placeholder: "Результат капчи",
                  obscureText: true,
                  controller: captcha,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  prefix: const Padding(
                    padding: EdgeInsets.only(
                      left: 8.0,
                    ),
                    child: Icon(
                      EcampusIcons.icons8_captcha,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDestructiveAction: false,
          onPressed: () {
            Navigator.pop(dialogContext);
            showLoadingDialog(context);
            print(captcha.text);
            SharedPreferences.getInstance().then((value) => {
                  ecampus
                      .authenticate(
                        value.getString("login") ?? "",
                        value.getString("password") ?? "",
                        captcha.text,
                      )
                      .then((response) => {
                            if (response.isSuccess)
                              {
                                print(response.userName),
                                value
                                    .setString("token", response.cookie)
                                    .then((_value) => {
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MyHomePage(
                                                title: 'eCampus',
                                              ),
                                            ),
                                          ),
                                        }),
                              }
                            else
                              {
                                ecampus.getCaptcha().then((value) => {
                                      Navigator.pop(context),
                                      showCapchaDialog(
                                        context,
                                        value,
                                        ecampus,
                                      ),
                                    }),
                              }
                          })
                });
          },
          child: const Text(
            "Подтверить",
          ),
        ),
        CupertinoDialogAction(
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

void showLoadingDialog(BuildContext context) {
  showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: const Text("Загрузка..."),
      content: Center(
        child: Column(
          children: const [
            SizedBox(
              height: 12,
            ),
            CupertinoActivityIndicator(
              radius: 12,
            )
          ],
        ),
      ),
    ),
  );
}
