import 'package:ecampus_ncfu/ecampus_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: CupertinoButton(
          child: const Icon(EcampusIcons.icons8_buy_upgrade),
          onPressed: () {},
        ),
        actions: [
          CupertinoButton(
              child: const Icon(EcampusIcons.icons8_notification),
              onPressed: () {
                //do somemthig
              })
        ],
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        title: Text(widget.title, style: Theme.of(context).textTheme.titleSmall,),
      ),
      body: Center(
        child: Text("test", style: Theme.of(context).textTheme.bodySmall,)
      ),
    );
  }
}
