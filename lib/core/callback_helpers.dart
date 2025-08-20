import 'package:geolocator/geolocator.dart';

import '../app/app_logger_setup.dart';
import 'model/location_entity.dart';
import 'model/marker_entity.dart';
import 'db/app_database.dart';

Future<List<MarkerEntity>> getBackgroundRemindersInRangeAndTime(
  LocationEntity currentPosition,
) async {
  List<MarkerEntity> markers = [];
  try {
    // Fixed: Handle Stream by taking the first emission
    final markerRes = await AppDatabase.instance.taskDao.fetchGeofenceMarkers();

    if (markerRes.isEmpty) {
      logger.error(
        'no reminders in database, skipping range and time check',
        error: "",
        name: "GeoTaask",
      );
      return [];
    }

    markers =
        markerRes
            .where(
              (reminder) =>
                  reminder.isActive() &&
                  reminder.hasBegun() &&
                  reminder.isNotExpired() &&
                  reminder.isInRange(currentPosition),
            )
            .toList();

    logger.debug(
      "=== Available Reminders/Markers in geofence: ${markers.length} ==",
      name: "GeoTaask",
    );
  } catch (e, s) {
    _onError(e, s);
    markers = [];
  }

  return markers;
}

// Future<LocationEntity> _getLocation() async {
//   final lService = locator<LocationService>();
//   final coordinate = await lService.getCurrentPosition();
//   logger.debug(
//     '=== Retrieved location: ${coordinate.toString()} ===',
//     name: "GeoTaask",
//   );
//   return coordinate;
// }

Future<Position?> getCurrentPositionWithFallback() async {
  try {
    // Try last known position first
    Position? lastPosition = await Geolocator.getLastKnownPosition();
    if (lastPosition != null) {
      // Check if it's recent enough (e.g., within last 5 minutes)
      if (DateTime.now().difference(lastPosition.timestamp).inMinutes < 5) {
        return lastPosition;
      }
    }

    // If no recent cached position, get current
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.medium,
      timeLimit: Duration(seconds: 45),
    );
  } catch (e) {
    // Return last known position as fallback
    return await Geolocator.getLastKnownPosition();
  }
}

void _onError(Object error, StackTrace stackTrace) {
  logger.error(
    '=== Error executing workmanager task: $error\n$stackTrace ===',
    name: "GoeTaask",
  );
}
