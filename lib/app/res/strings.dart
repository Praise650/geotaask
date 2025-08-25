class Strings {
  static const String mapKey = 'AIzaSyCrXpSHurKH2wXwSLIKmIpeckjLKutRH7I';
}

abstract class Common {
  static late String appName;
  static late String appVersion;
  static late String packageName;
  static late String buildNumber;

  static const int appStartYear = 2024;

  static const int magicalWaitTimeInMs = 1500;

  // Platform.isIOS doesn't allow overriding in tests
  // static bool isIOS(context) =>
  //     Theme.of(context).platform == TargetPlatform.iOS;
  // static bool isAndroid(context) =>
  //     Theme.of(context).platform == TargetPlatform.android;
}