import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:ecampus_ncfu/ecampus_master/ecampus.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WifiPage extends StatefulWidget {
  WifiPage({Key? key, required this.ecampus}) : super(key: key);

  final eCampus ecampus;

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  String password = "";
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
              Text(
                  "Для доступа к беспроводной сети в корпусах и общежитиях университета необходимо активировать единую учётную запись и настроить своё беспроводное устройство на доступ к сети “ncfu”.\n\nДля активации учётной записи или смены пароля нажмите кнопку \"Создать новый пароль\". Операция будет выполнена в течение 10 минут.\n\nПросмотреть текущий или восстановить старый пароль невозможно."),
              Divider(
              ),
              Text(
                "Имя пользователья",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text("mekubov", style: Theme.of(context).textTheme.bodyMedium),
              SizedBox(
                height: 12,
              ),
              password == "undefined" || password == ""
                  ? SizedBox()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Пароль",
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(password,
                            style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
              SizedBox(
                height: 12,
              ),
              SizedBox(
                width: double.infinity,
                child: CupertinoButton(
                  onPressed: () async {
                    password = await widget.ecampus.resetWiFi();
                    setState(() {});
                    if (password == "undefined") {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Ошибка'),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Готово'),
                        ),
                      );
                    }
                  },
                  child: Text(
                    "Сбросить пароль",
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  color: primaryColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
