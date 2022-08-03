import 'dart:io';
import 'dart:typed_data';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/dialogs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.context}) : super(key: key);

  final BuildContext context;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController captcha = TextEditingController();

  late eCampus ecampus;
  Uint8List? captchaImage;
  bool isLogined = true;
  bool loading = false;

  void solveCapcha() {
    ecampus.getCaptcha().then((value) => {
      showCapchaDialog(context, value, ecampus)
    },);
  }

  @override
  void initState() {
    super.initState();
    String cookie;
    SharedPreferences.getInstance().then((value) => {
          cookie = value.getString("token") ?? 'undefined',
          if (value.getBool("isLogin") ?? false)
            {
              ecampus = eCampus(value.getString("token") ?? "undefined"),
              ecampus.isActualToken().then((value) => {
                    if (value)
                      {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MyHomePage(
                                    title: 'eCampus',
                                  )),
                        )
                      }
                    else{
                      print("solveCaptcha"),
                      solveCapcha()
                    }
                  })
            }
          else
            {
              setState(() {
                isLogined = false;
              }),
              ecampus = eCampus("undefined"),
              ecampus.getCaptcha().then((value) => {
                    setState(() {
                      captchaImage = value;
                      captcha.text = "";
                      print(ecampus.getCookies());
                    })
                  })
            },
        });
  }

  void updateCapcha() {
    setState(() {
      captchaImage = null;
    });
    ecampus.getCaptcha().then((value) => {
          setState(() {
            captchaImage = value;
            captcha.text = "";
            print(ecampus.getCookies());
          })
        });
  }

  void _showAlertDialog(
      BuildContext context, String title, String msg, String action) {
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
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(action),
          )
        ],
      ),
    );
  }

  void login() {
    setState(() {
      loading = true;
    });
    ecampus
        .authenticate(username.text, password.text, captcha.text)
        .then((response) => {
              if (response.isSuccess)
                {
                  SharedPreferences.getInstance().then(
                    (value) => {
                      value.setBool("isLogin", true),
                      value.setString("login", username.text),
                      value.setString("password", password.text),
                      value.setString("token", response.cookie),
                      value.setString("userName", response.userName)
                    },
                  ),
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyHomePage(
                              title: 'eCampus',
                            )),
                  )
                }
              else
                {
                  password.text = "",
                  _showAlertDialog(
                      context, "eCampus", response.error, "Попробовать снова")
                },
              ecampus.client.clearCookies(),
              updateCapcha(),
              setState(() {
                loading = false;
              })
            });
    //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyHomePage(title: "ecampus")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: SafeArea(
        child: Text(
          "Created by Muhammadqodir",
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      body: Center(
          child: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          const Icon(
            EcampusIcons.icons8_student_male,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "eCampus",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          !isLogined
              ? Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: 12.0,
                      horizontal: MediaQuery.of(context).size.width / 5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 12,
                      ),
                      CupertinoTextField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(10),
                        placeholder: "Имя пользователья",
                        textInputAction: TextInputAction.next,
                        controller: username,
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            EcampusIcons.icons8_user,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      CupertinoTextField(
                        style: Theme.of(context).textTheme.bodyMedium,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12)),
                        padding: const EdgeInsets.all(10),
                        placeholder: "Пароль",
                        obscureText: true,
                        enableSuggestions: false,
                        controller: password,
                        autocorrect: false,
                        keyboardType: TextInputType.text,
                        textInputAction: TextInputAction.done,
                        prefix: const Padding(
                          padding: EdgeInsets.only(left: 8.0),
                          child: Icon(
                            EcampusIcons.icons8_password,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Введите результат выражения:",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(
                        height: 3,
                      ),
                      captchaImage == null
                          ? Column(
                              children: const [
                                SizedBox(
                                  height: 9,
                                ),
                                CupertinoActivityIndicator(
                                  radius: 12,
                                  color: Colors.white,
                                ),
                              ],
                            )
                          : Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(12)),
                                      child: Image.memory(
                                        captchaImage!,
                                        height: 42,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    CupertinoButton(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                        padding: const EdgeInsets.all(3),
                                        child: const Icon(
                                          EcampusIcons.icons8_restart,
                                          size: 18,
                                          color: Colors.black,
                                        ),
                                        onPressed: () => updateCapcha())
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
                      const SizedBox(
                        height: 20,
                      ),
                      !loading
                          ? CupertinoButton(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "Войти",
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(
                                    width: 4,
                                  ),
                                  const Icon(
                                    EcampusIcons.icons8_login,
                                    color: Colors.black87,
                                  )
                                ],
                              ),
                              onPressed: () => login())
                          : const CupertinoActivityIndicator(
                              radius: 12,
                              color: Colors.white,
                            ),
                    ],
                  ),
                )
              : const Padding(
                  padding: EdgeInsets.all(12),
                  child: CupertinoActivityIndicator(
                    radius: 12,
                    color: Colors.white,
                  ),
                ),
        ]),
      )),
    );
  }
}
