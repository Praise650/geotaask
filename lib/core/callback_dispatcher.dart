import 'dart:convert';
import 'dart:ui';

import 'package:workmanager/workmanager.dart';

import 'services/notification_service.dart';
import '../app/app_setup.locator.dart';
import '../app/app_logger_setup.dart';
import 'model/location_entity.dart';
import 'model/marker_entity.dart';
import 'callback_helpers.dart';
import 'db/app_database.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  logger.debug('=== GEOFENCE TRIGGERED START ===', name: "GeoTaask");
  Workmanager().executeTask((taskName, inputData) async {
    // Set up dependencies for this isolate
    await AppDatabase.init();
    await setupLocator();
    await initLogging();
    logger.debug(
      '=== Executing workmanager task: $taskName ===',
      name: "GeoTaask",
    );
    try {
      /* doesn't work:
      Location location = Location();
      location.enableBackgroundMode(enable: true);
      LocationData currentLocation = await location.getLocation();
      // throws a java.lang.NullPointerException, hence we use Geolocator
      */
      // required for geolocation
      DartPluginRegistrant.ensureInitialized();
      final currentLocation = await getCurrentPositionWithFallback();

      final remindersInRange = await getBackgroundRemindersInRangeAndTime(
        LocationEntity(
          latitude: currentLocation!.latitude,
          longitude: currentLocation.longitude,
        ),
      );

      // This commented section in brackets is implementation
      // for displaying notifications
      // This loop builds a comma-separated string of all the
      // reminders that are currently in range.
      //  For the first reminder: adds it directly (no comma)
      // For subsequent reminders: adds a comma and space before each reminder
      // [
      // String message = '';
      // for (MarkerEntity reminder in remindersInRange) {
      //   message += message.isEmpty ? '$reminder' : ', $reminder';
      // }
      //
      // if (message.trim().isEmpty) {
      //   logger.debug(
      //     '=== Message is empty, skipping notification ===',
      //     name: "GeoTaask",
      //   );
      // } else {
      //   await NotificationService().showLocalNotification(
      //     id: 0, // same ID updates/overwrites previous notification, intended
      //     title: "Howdy!",
      //     body: "GeoTaask reminds you: $message",
      //     payload: "GeoTaask reminder: $message",
      //   );
      // }
      // ]


      if (remindersInRange.isEmpty) {
        logger.debug(
          '=== No reminders in range, skipping notifications ===',
          name: "GeoTaask",
        );
      } else {
        // Show separate notification for each reminder
        for (int i = 0; i < remindersInRange.length; i++) {
          MarkerEntity reminder = remindersInRange[i];

          await NotificationService().showLocalNotification(
            id: reminder.id ?? 0, // Use reminder's unique ID instead of 0
            title: "Howdy!, GeoTaask Reminder",
            body: reminder.description!, // or reminder.title/description
            payload: jsonEncode({
              'type': 'geotask_reminder',
              'reminder_id': reminder.markerId,
              'reminder_data': reminder.toJson(), // if you have this method
            }),
          );
        }

        logger.debug(
          '=== Sent ${remindersInRange.length} notifications ===',
          name: "GeoTaask",
        );
      }
    } catch (e, s) {
      _onError(e, s);
    }
    logger.debug('=== GEOFENCE TRIGGERED END ===', name: "GeoTaask");

    return Future.value(true);
  });
}

void _onError(Object error, StackTrace stackTrace) {
  logger.error(
    '=== Error executing workmanager task: $error\n$stackTrace ===',
    error: "$error\n$stackTrace",
    name: "GoeTaask",
  );
}