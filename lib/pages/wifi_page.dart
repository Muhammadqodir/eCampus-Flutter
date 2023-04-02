import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/inc/copy_row.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WifiPage extends StatefulWidget {
  WifiPage({Key? key, required this.ecampus}) : super(key: key);

  final eCampus ecampus;

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  String password = "";
  String userName = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _getFromCache();
  }

  _getFromCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String login = preferences.getString("wLogin") ?? "undefined";
    if (login == "undefined" || login == "") {
      _getWifiLogin();
    } else {
      userName = login;
      password = preferences.getString("wPassword") ?? "undefined";
      setState(() {});
    }
  }

  _getWifiLogin() async {
    userName = await widget.ecampus.getWifiUserName();

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("wLogin", userName);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
          child: const Icon(EcampusIcons.icons8_back),
        ),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(
          "Wi-Fi",
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CopyRow(
                title: "Имя пользователья",
                value: userName,
              ),
              const SizedBox(
                height: 6,
              ),
              password == "undefined" || password == ""
                  ? SizedBox()
                  : CopyRow(title: "Пароль", value: password),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  onPressed: _getNewPassword,
                  color: primaryColor,
                  child: Text(
                    "Получить новый пароль",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                "Для доступа к беспроводной сети в корпусах и общежитиях университета необходимо активировать единую учётную запись и настроить своё беспроводное устройство на доступ к сети “ncfu”.\n\nДля активации учётной записи или смены пароля нажмите кнопку \"Создать новый пароль\". Операция будет выполнена в течение 10 минут.\n\nПросмотреть текущий или восстановить старый пароль невозможно.",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _getNewPassword() async {
    String tempPassword = await widget.ecampus.resetWiFi();
    if (tempPassword == "undefined") {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ошибка!'),
        ),
      );
    } else {
      password = tempPassword;

      setState(() {});
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString("wLogin", userName);
      preferences.setString("wPassword", password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Готово!'),
        ),
      );
    }
  }
}
