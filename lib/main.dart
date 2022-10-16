import 'dart:developer';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:ecampus_ncfu/pages/login_page.dart';
import 'package:ecampus_ncfu/themes.dart';
import 'package:ecampus_ncfu/utils/system_info.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:stack_appodeal_flutter/stack_appodeal_flutter.dart';
import 'firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");

  if (message.notification != null) {
    print('Message also contained a notification: ${message.notification}');
    AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 10,
          channelKey: 'basic_channel',
          title: message.notification?.title,
          body: message.notification?.body),
    );
  }
}

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

  AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
          channelGroupKey: 'basic_channel_group',
          channelKey: 'basic_channel',
          channelName: 'Basic notifications',
          channelDescription: 'Notification channel for basic tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white)
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
          channelGroupkey: 'basic_channel_group',
          channelGroupName: 'Basic group')
    ],
    debug: true,
  );


  Appodeal.setAutoCache(AppodealAdType.Banner, true);
  Appodeal.setAutoCache(AppodealAdType.Interstitial, true);
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
    onBannerExpired: () => {},
  );
  await Appodeal.initialize(
    appKey: SystemInfo().isAndroid
        ? "dd06c2f575de12196c482dd6ac26713a1b561f523fcb7680"
        : "956b48be6f5e431c8b66c74585549b1c52c56a8438135935",
    adTypes: [
      AppodealAdType.Interstitial,
      AppodealAdType.Banner,
    ],
    onInitializationFinished: (errors) {
      if(errors!.isNotEmpty){
      log("AppodealError" + errors.toString());
      }
    },
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print('Got a message whilst in the foreground!');
    print('Message data: ${message.data}');

    if (message.notification != null) {
      print('Message also contained a notification: ${message.notification}');
      AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: 10,
            channelKey: 'basic_channel',
            title: message.notification?.title,
            body: message.notification?.body),
      );
    }
  });

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

class ScheduledTask {
  static const String taskName = "control";
  static void control() {
    // add your control here
  }
}
