import 'dart:developer' as dev;

import 'package:native_geofence/native_geofence.dart';

import '../callback.dart';
import '../model/marker_entity.dart';

class GeoFenceService {
  // step 1
  Future<void> initializeFencing({bool background = false}) async {
    try {
      dev.log('Initializing...', name: "GeofenceService.initialize");
      await NativeGeofenceManager.instance.initialize();
      dev.log('Initialization done', name: "GeofenceService.initialize");
      final res = await getRegisteredRegion();
      dev.log("Registered Fences: $res", name: "GeofenceService.initialize");
    } catch (e, s) {
      _onError(e, s);
    }
  }

  //save geofence markers
  // Future<void> registerGeoTags(List<TagLocationEntity> region) async {
  //   try {
  //     // Start geofencing with the regions
  //     // Convert TagLocationEntity list to Set<GeofenceRegion>
  //     final Set<GeofenceRegion> regions =
  //         region
  //             .where(
  //               (marker) =>
  //                   marker.latitude != null &&
  //                   marker.longitude != null &&
  //                   marker.markerId != null,
  //             )
  //             .map(
  //               (marker) => GeofenceRegion.circular(
  //                 id: marker.markerId!,
  //                 center: LatLng(marker.latitude!, marker.longitude!),
  //                 data: {
  //                   "title": marker.title,
  //                   "description": marker.description,
  //                   "created_at": marker.createdAt,
  //                 },
  //                 radius: 100.0, // Set your desired radius in meters
  //               ),
  //             )
  //             .toSet();
  //     await Geofencing.instance.start(regions: regions);
  //   } catch (e) {
  //     print('Error registering geotags: $e');
  //     // Handle error appropriately
  //   }
  // }

  Future<int> getRegisteredRegion() async {
    final res = await NativeGeofenceManager.instance.getRegisteredGeofenceIds();
    return res.length;
  }

  Future<void> addGeofenceRegion(MarkerEntity region) async {
    try {
      await NativeGeofenceManager.instance.createGeofence(
        Geofence(
          id: region.markerId!,
          location: Location(
            latitude: region.latitude!,
            longitude: region.longitude!,
          ),
          radiusMeters: region.radius!,
          triggers: {
            GeofenceEvent.enter,
            GeofenceEvent.exit,
            GeofenceEvent.dwell,
          },
          iosSettings: IosGeofenceSettings(initialTrigger: true),
          androidSettings: AndroidGeofenceSettings(
            initialTriggers: {GeofenceEvent.enter},
            expiration: const Duration(days: 7),
            loiteringDelay: const Duration(seconds: 60),
            notificationResponsiveness: const Duration(milliseconds: 300),
          ),
        ),
        geofenceTriggered,
      );
      final res = await getRegisteredRegion();
      dev.log("Fence Added: ${region.toJson()}", name: "GeofenceService.initialize");
      dev.log("Registered Fences: $res", name: "GeofenceService.initialize");
    } catch (e, s) {
      _onError(e, s);
      rethrow;
    }
  }

  Future<void> deleteGeofenceRegion(String markerId) async {
    try {
      await NativeGeofenceManager.instance.removeGeofenceById(markerId);
      final res = await getRegisteredRegion();
      dev.log("Registered Fences: $res", name: "GeofenceService.initialize");
    } catch (e, s) {
      _onError(e, s);
      rethrow;
    }
  }

  Future<void> stopGeofenceService() async {
    try {
      await NativeGeofenceManager.instance.removeAllGeofences();
    } catch (e, s) {
      _onError(e, s);
      rethrow;
    }
  }

  void _onError(Object error, StackTrace stackTrace) {
    dev.log('error: $error\n$stackTrace');
  }
}
