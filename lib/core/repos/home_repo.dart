// Repository Interface

import '../db/app_database.dart';
import '../model/marker_entity.dart';
import '../services/geo_fence_service.dart';

abstract class HomeRepository {
  Stream<List<MarkerEntity>> fetchGeoFenceMarkers();
  Future<MarkerEntity?> fetchGeofenceMarker(String markerId);
  Future<void> addGeofenceMarker(MarkerEntity item);
  Future<void> updateGeofenceMarker(MarkerEntity item);
  Future<void> completeGeofenceMarker(MarkerEntity item);
  Future<void> deleteGeofenceMarker(String markerId);
}

// Repository Implementation
class HomeRepositoryImpl implements HomeRepository {
  final AppDatabase _dbService;
  final GeoFenceService _geoFenceService;

  HomeRepositoryImpl({AppDatabase? dbService, GeoFenceService? geoFenceService})
    : _dbService = dbService ?? AppDatabase.instance,
      _geoFenceService = geoFenceService ?? GeoFenceService();

  @override
  Stream<List<MarkerEntity>> fetchGeoFenceMarkers() =>
      _dbService.taskDao.getGeofenceMarkers();

  @override
  Future<MarkerEntity?> fetchGeofenceMarker(String markerId) async {
    try {
      final result = await _dbService.taskDao.getGeofenceMarkerByMarkerId(
        markerId,
      );
      return result;
    } catch (e) {
      throw Exception('Unable to fetch marker detail: $e');
    }
  }

  @override
  Future<void> addGeofenceMarker(MarkerEntity region) async {
    try {
      await _geoFenceService.addGeofenceRegion(region); // Add geofence first
      try {
        await _dbService.taskDao.createGeofenceMarker(region); // Then database
      } catch (e) {
        // Rollback geofence if database fails
        await _geoFenceService.deleteGeofenceRegion(region.markerId!);
        throw Exception('Failed to add geofence marker: $e');
      }
    } catch (e) {
      throw Exception('Failed to add geofence region: $e');
    }
  }

  @override
  Future<void> updateGeofenceMarker(MarkerEntity region) async {
    await _dbService.taskDao.updateGeofenceMarker(region);
    await _geoFenceService.deleteGeofenceRegion(region.markerId!);
    await _geoFenceService.addGeofenceRegion(region);
  }

  @override
  Future<void> completeGeofenceMarker(MarkerEntity region) async {
    await _dbService.taskDao.updateGeofenceMarker(region);
    await _geoFenceService.deleteGeofenceRegion(region.markerId!);
  }

  @override
  Future<void> deleteGeofenceMarker(String markerId) async {
    await _dbService.taskDao.deleteGeofenceMarkerByMarkerId(markerId);
    await _geoFenceService.deleteGeofenceRegion(markerId);
  }
}
