import 'dart:typed_data';

import 'package:ecampus_ncfu/inc/cross_button.dart';
import 'package:ecampus_ncfu/inc/cross_dialog.dart';
import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/pages/main_page.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../inc/cross_activity_indicator.dart';
import '../inc/cross_text_field.dart';
import '../utils/dialogs.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    Key? key,
    required this.context,
  }) : super(key: key);

  final BuildContext context;
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController captcha = TextEditingController();

  late ECampus ecampus;
  Uint8List? captchaImage;
  bool isLogined = true;
  bool loading = false;

  void solveCapcha() {
    ecampus.getCaptcha().then(
          (value) => {
            showCapchaDialog(
              context,
              value,
              ecampus,
            )
          }, //!
        );
  }

  @override
  void initState() {
    super.initState();
    String cookie;
    SharedPreferences.getInstance().then((value) => {
          cookie = value.getString("token") ?? 'undefined',
          if (value.getBool("isLogin") ?? false)
            {
              ecampus = ECampus(value.getString("token") ?? "undefined"),
              ecampus.isActualToken().then((value) => {
                    if (value)
                      {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyHomePage(
                              title: 'eCampus',
                            ),
                          ),
                        )
                      }
                    else
                      {
                        print("solveCaptcha"),
                        solveCapcha(),
                      }
                  })
            }
          else
            {
              setState(() {
                isLogined = false;
              }),
              ecampus = ECampus("undefined"),
              ecampus.getCaptcha().then((value) => {
                    setState(() {
                      captchaImage = value;
                      captcha.text = "";
                      print(
                        ecampus.getCookies(),
                      );
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
    BuildContext context,
    String title,
    String msg,
    String action,
  ) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) => CrossDialog(
        title: title,
        content: msg,
        actions: <CrossDialogAction>[
          CrossDialogAction(
            isDestructiveAction: false,
            onPressed: () {
              Navigator.pop(context);
            },
            child: action,
          ),
        ],
      ),
    );
  }

  void login() {
    setState(() {
      loading = true;
    });
    ecampus
        .authenticate(
          username.text,
          password.text,
          captcha.text,
        )
        .then((response) => {
              if (response.isSuccess)
                {
                  SharedPreferences.getInstance().then(
                    (value) => {
                      value.setBool(
                        "isLogin",
                        true,
                      ),
                      value.setString(
                        "login",
                        username.text,
                      ),
                      value.setString(
                        "password",
                        password.text,
                      ),
                      value.setString(
                        "token",
                        response.cookie,
                      ),
                      value.setString(
                        "userName",
                        response.userName,
                      )
                    },
                  ),
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MyHomePage(
                        title: 'eCampus',
                      ),
                    ),
                  ),
                }
              else
                {
                  password.text = "",
                  _showAlertDialog(
                    context,
                    "eCampus",
                    response.error,
                    "Попробовать снова",
                  ),
                },
              ecampus.client.clearCookies(),
              updateCapcha(),
              setState(() {
                loading = false;
              }),
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
                        horizontal: MediaQuery.of(context).size.width / 5,
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 12,
                          ),
                          CrossTextField(
                            width: 250,
                            height: 45,
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.all(10),
                            placeholder: "Имя пользователя",
                            textInputAction: TextInputAction.next,
                            controller: username,
                            prefix: const Padding(
                              padding: EdgeInsets.only(
                                left: 8.0,
                              ),
                              child: Icon(
                                EcampusIcons.icons8_user,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 12,
                          ),
                          CrossTextField(
                            width: 250,
                            height: 45,
                            textStyle: Theme.of(context).textTheme.bodyMedium,
                            backgroundColor: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            padding: const EdgeInsets.all(10),
                            placeholder: "Пароль",
                            obscureText: true,
                            enableSuggestions: false,
                            controller: password,
                            autocorrect: false,
                            keyboardType: TextInputType.text,
                            textInputAction: TextInputAction.done,
                            prefix: const Padding(
                              padding: EdgeInsets.only(
                                left: 8.0,
                              ),
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
                            height: 5,
                          ),
                          captchaImage == null
                              ? Column(
                                  children: const [
                                    SizedBox(
                                      height: 9,
                                    ),
                                    CrossActivityIndicator(
                                      radius: 12,
                                      color: Colors.white,
                                    ),
                                  ],
                                )
                              : Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.all(
                                            Radius.circular(12),
                                          ),
                                          child: Image.memory(
                                            captchaImage!,
                                            height: 45,
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        CrossButton(
                                          height: 45,
                                          wight: 45,
                                          backgroundColor: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(12),
                                          padding: const EdgeInsets.all(3),
                                          child: const Icon(
                                            EcampusIcons.icons8_restart,
                                            size: 18,
                                            color: Colors.black,
                                          ),
                                          onPressed: () => updateCapcha(),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    CrossTextField(
                                      width: 250,
                                      height: 45,
                                      textStyle: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                      padding: const EdgeInsets.all(10),
                                      backgroundColor: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
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
                          const SizedBox(
                            height: 20,
                          ),
                          !loading
                              ? CrossButton(
                                  height: 40,
                                  onPressed: () => login(),
                                  backgroundColor: Colors.white,
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                  ),
                                  borderRadius: BorderRadius.circular(
                                    12.0,
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Войти",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                      ),
                                      const SizedBox(
                                        width: 4,
                                      ),
                                      const Icon(
                                        EcampusIcons.icons8_login,
                                        color: Colors.black87,
                                      ),
                                    ],
                                  ),
                                )
                              : const CrossActivityIndicator(
                                  radius: 12,
                                  color: Colors.white,
                                ),
                        ],
                      ),
                    )
                  : const Padding(
                      padding: EdgeInsets.all(12),
                      child: CrossActivityIndicator(
                        radius: 12,
                        color: Colors.white,
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
