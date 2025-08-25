import 'package:workmanager/workmanager.dart';
import 'package:geotaask/utils/extensions.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:package_info_plus/package_info_plus.dart';

import '../core/services/notification_service.dart';
import '../core/callback_dispatcher.dart';
import 'app_setup.locator.dart';
import 'app_logger_setup.dart';
import 'res/strings.dart';

class AppSetup {
  static Future<void> initApp() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    Common.appName = packageInfo.appName.capitalize();
    Common.appVersion = packageInfo.version;
    Common.packageName = packageInfo.packageName;
    Common.buildNumber = packageInfo.buildNumber;
    await setupLocator();
    // set up logging
    _initNotification();
    _initWorkManager();
  }

  static Future<void> _initNotification() async {
    final res = locator<NotificationService>();
    return await res.initializePlatformNotifications();
  }

  static void _initWorkManager() async {
    Workmanager().initialize(
      callbackDispatcher,
      // we use flutter_local_notifications
      // in callbackDispatcher
      isInDebugMode: false,
    );
    _initNotification();
    Workmanager().registerPeriodicTask(
      Common.packageName,
      Common.appName,
      initialDelay: Duration(seconds: 5),
      // give it some time to initialize, matches
      // iOS default ("earliestBeginInSeconds:5.0")
      // - see also AppDelegate.swift WorkmanagerPlugin.registerPeriodicTask
      frequency: Duration(minutes: 15),
      // see also/must match AppDelegate.swift
      // WorkmanagerPlugin.registerPeriodicTask
    );

    tz.initializeTimeZones();

    logger.debug('workmanager initialized');
  }
}
