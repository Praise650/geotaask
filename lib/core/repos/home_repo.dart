// Repository Interface

import '../db/app_database.dart';
import '../model/marker_entity.dart';

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

  HomeRepositoryImpl({AppDatabase? dbService})
    : _dbService = dbService ?? AppDatabase.instance;

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
      await _dbService.taskDao.createGeofenceMarker(region); // Then database
    } catch (e) {
      throw Exception('Failed to add geofence marker: $e');
    }
  }

  @override
  Future<void> updateGeofenceMarker(MarkerEntity region) async {
    try {
      await _dbService.taskDao.updateGeofenceMarker(region);
    } catch (e) {
      throw Exception('Failed to add geofence marker: $e');
    }
  }

  @override
  Future<void> completeGeofenceMarker(MarkerEntity region) async {
    try {
      await _dbService.taskDao.updateGeofenceMarker(region);
    } catch (e) {
      throw Exception('Failed to add geofence marker: $e');
    }
  }

  @override
  Future<void> deleteGeofenceMarker(String markerId) async {
    try {
      await _dbService.taskDao.deleteGeofenceMarkerByMarkerId(markerId);
    } catch (e) {
      throw Exception('Failed to add geofence marker: $e');
    }
  }
}
