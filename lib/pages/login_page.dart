import 'dart:typed_data';

import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master.dart/ecampus.dart';
import 'package:ecampus_ncfu/pages/main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, required this.context}) : super(key: key);

  final BuildContext context;
  @override
  State<LoginPage> createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage>{


  eCampus ecampus = eCampus("tftuckkg", "y8f7QaC4");
  Uint8List? captchaImage = null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      bottomNavigationBar: SafeArea(child: Text("Created by Muhammadqodir", textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall,),),
      body: Center(
          child: SafeArea(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(
            EcampusIcons.icons8_student_male,
            size: 100,
            color: Colors.white,
          ),
          Text(
            "eCampus",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                vertical: 12.0,
                horizontal: MediaQuery.of(context).size.width / 5),
            child: Column(
              children: [
                SizedBox(
                  height: 12,
                ),
                CupertinoTextField(
                  padding: EdgeInsets.all(10),
                  placeholder: "Имя пользователья",
                  textInputAction: TextInputAction.next,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      EcampusIcons.icons8_user,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                CupertinoTextField(
                  padding: EdgeInsets.all(10),
                  placeholder: "Пароль",
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  prefix: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Icon(
                      EcampusIcons.icons8_password,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                captchaImage != null ? Image.memory(captchaImage!) : Text("Captcha is loading", style: Theme.of(context).textTheme.headlineSmall,),
                CupertinoButton(
                    color: Colors.white,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Войти",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        SizedBox(width: 4,),
                        Icon(EcampusIcons.icons8_login, color: Colors.black87,)
                      ],
                    ),
                    onPressed: () {
                      ecampus.getCaptcha().then((value) => {
                        setState((){
                          captchaImage = value;
                        })
                      });
                      //Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>MyHomePage(title: "ecampus")));
                    })
              ],
            ),
          )
        ]),
      )),
    );
  } 
  
}
