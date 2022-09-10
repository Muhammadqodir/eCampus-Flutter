import 'dart:developer';

import 'package:ecampus_ncfu/pages/login_page.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:ecampus_ncfu/utils/system_info.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'firebase_options.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  Appodeal.initialize(
    appKey: SystemInfo().isAndroid
        ? "dd06c2f575de12196c482dd6ac26713a1b561f523fcb7680"
        : "956b48be6f5e431c8b66c74585549b1c52c56a8438135935",
    adTypes: [
      AppodealAdType.Interstitial,
      AppodealAdType.Banner,
    ],
    onInitializationFinished: (errors) {
      log("AppodealError" + errors.toString());
    },
  );
  Appodeal.setBannerCallbacks(
      onBannerLoaded: (isPrecache) => {},
      onBannerFailedToLoad: () {
        log("Failed to load ad:");
      },
      onBannerShown: () => {},
      onBannerShowFailed: () {
        log("onBannerShowFailed");
      },
      onBannerClicked: () => {},
      onBannerExpired: () => {});

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  final bool isLogin = false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eCampus',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      home: LoginPage(context: context),
    );
  }
}
