import 'dart:io' show Platform;

class SystemInfo {

  bool isIos = false;
  bool isAndroid = true;

  static final SystemInfo _systemInfo = SystemInfo._internal();

  factory SystemInfo() {
    _systemInfo.initInfo();
    return _systemInfo;
  }

  SystemInfo._internal();

  void initInfo() {
    if (Platform.isIOS) {
      isIos = true;
      isAndroid = false;
    }
  }
}
