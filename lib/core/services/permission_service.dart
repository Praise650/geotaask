import 'package:permission_handler/permission_handler.dart';

import '../../app/app_logger_setup.dart';

class PermissionService {
  Future<bool> checkPermissions() async {
    /* we'll not check the following permission callbacks here:

     - onRestrictedCallback is for "active restrictions such as parental controls" (iOS only) (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L138)
     - onLimitedCallback is "for limited photo library access" (iOS only) (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L143C44-L143C76)

     generell remarks reg.

     - onGrantedCallback is needed as permissions can be granted during app usage
     - onPermanentlyDeniedCallback: no new permission dialog will be shown, redirect user to App settings page for permissions
     - onProvisionalCallback: iOS only, "provisionally authorized to post noninterruptive user notifications" (https://github.com/Baseflow/flutter-permission-handler/blob/main/permission_handler/lib/permission_handler.dart#L154C29-L154C96)
  */
    logger.debug('checking permissions', name: '$runtimeType');

    bool locationGranted = false;
    bool locationAlwaysGranted = false;
    bool notificationGranted = false;

    await Permission.location
        .onGrantedCallback(() {
          locationGranted = true;
          logger.debug('location granted', name: '$runtimeType');
        })
        .onDeniedCallback(() {
          logger.debug('location denied', name: '$runtimeType');
        })
        .onPermanentlyDeniedCallback(() {
          logger.debug('location permanently denied', name: '$runtimeType');
        })
        .onProvisionalCallback(() {
          logger.debug('location provisional', name: '$runtimeType');
        })
        .request();

    await Permission.locationAlways
        .onGrantedCallback(() {
          logger.debug('locationAlways granted', name: '$runtimeType');
          locationAlwaysGranted = true;
        })
        .onDeniedCallback(() {
          logger.debug('locationAlways denied', name: '$runtimeType');
        })
        .onPermanentlyDeniedCallback(() {
          logger.debug(
            'locationAlways permanently denied',
            name: '$runtimeType',
          );
        })
        .onProvisionalCallback(() {
          logger.debug('locationAlways provisional', name: '$runtimeType');
        })
        .request();

    await Permission.notification
        .onGrantedCallback(() {
          logger.debug('notification granted', name: '$runtimeType');
          notificationGranted = true;
        })
        .onDeniedCallback(() {
          logger.debug('notification denied', name: '$runtimeType');
        })
        .onPermanentlyDeniedCallback(() {
          logger.debug('notification permanently denied', name: '$runtimeType');
        })
        .onProvisionalCallback(() {
          logger.debug('notification provisional', name: '$runtimeType');
        })
        .request();

    bool overallGranted =
        locationGranted && locationAlwaysGranted && notificationGranted;
    // _ref.read(arePermissionsGrantedStateProvider.notifier).state = overallGranted;
    logger.debug('overallGranted = $overallGranted', name: '$runtimeType');

    if (!overallGranted) {
      logger.release(
        'permissions not granted, core functionality will not work',
        name: '$runtimeType',
      );
    }

    return overallGranted;
  }

  Future<bool> requestBackgroundLocationPermission() async {
    // Request foreground location permission
    PermissionStatus foregroundStatus =
    await Permission.locationWhenInUse.request();

    if (foregroundStatus.isGranted) {
      // Request background location permission
      PermissionStatus backgroundStatus =
      await Permission.locationAlways.request();

      if (backgroundStatus.isGranted) {
        logger.debug('Background location permission granted');
        return true;
      } else if (backgroundStatus.isDenied ||
          backgroundStatus.isPermanentlyDenied) {
        logger.debug('Background location permission denied');
        if (backgroundStatus.isPermanentlyDenied) {
          // Guide user to app settings
          await openAppSettings();
        }
        return false;
      }
    } else {
      logger.debug('Foreground location permission denied');
      if (foregroundStatus.isPermanentlyDenied) {
        // Guide user to app settings
        await openAppSettings();
      }
      return false;
    }
    return false;
  }
}
