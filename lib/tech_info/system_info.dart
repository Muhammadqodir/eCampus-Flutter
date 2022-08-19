import 'dart:io' show Platform;

class SystemInfo {
  String? osVersion, deviceModel;
  //var deviceInfo, androidInfo, release, sdkInt, manufacturer, model;
  //var iosInfo, systemName, version, name;

  bool isIos = false;
  bool isAndroid = true;

  static final SystemInfo _systemInfo = SystemInfo._internal();

  factory SystemInfo() {
    _systemInfo.initInfo();
    return _systemInfo;
  }

  SystemInfo._internal();

  void initInfo() {
    //print("I'm here");
    // if (Platform.isAndroid) {
    //   androidInfo = DeviceInfoPlugin().androidInfo;
    //   //release = androidInfo.version;
    //   sdkInt = androidInfo.version.sdkInt;
    //   manufacturer = androidInfo.manufacturer;
    //   model = androidInfo.model;
    // }

    if (Platform.isIOS) {
      // iosInfo = DeviceInfoPlugin().iosInfo;
      // systemName = iosInfo.systemName;
      // version = iosInfo.systemVersion;
      // name = iosInfo.name;
      // model = iosInfo.model;
      isIos = true;
      isAndroid = false;
    }
  }
}
