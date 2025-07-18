import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart' hide LocationServiceDisabledException;

import '../exceptions/location_exception.dart';
import '../model/location_entity.dart';

class LocationService {
  // Check if location services are enabled
  Future<bool> _isLocationServiceEnabled() async =>
      await Geolocator.isLocationServiceEnabled();

  // Check location permission status
  Future<LocationPermission> _checkPermission() async =>
      await Geolocator.checkPermission();

  // Request location permission
  Future<LocationPermission> _requestPermission() async =>
      await Geolocator.requestPermission();

  //step 1 initialise
  Future<void> checkLocationPermission() async{
    // Check if location services are enabled
    bool serviceEnabled = await _isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw LocationServiceDisabledException('Location services are disabled');
    }

    // Check permissions
    LocationPermission permission = await _checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _requestPermission();
      if (permission == LocationPermission.denied) {
        throw LocationPermissionDeniedException(
          'Location permissions are denied',
        );
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw LocationPermissionDeniedException(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }
  }

  // Future<LocationPermissionStatus> initLocationPermission() async {
  //   bool serviceEnabled = await _isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     return LocationPermissionStatus.serviceDisabled;
  //   }
  //
  //   LocationPermission permission = await _checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await _requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       return LocationPermissionStatus.denied;
  //     }
  //   }
  //
  //   if (permission == LocationPermission.deniedForever) {
  //     return LocationPermissionStatus.permanentlyDenied;
  //   }
  //
  //   return LocationPermissionStatus.granted;
  // }

  // Get current position
  Future<LocationEntity> getCurrentPosition() async {
    final position = await Geolocator.getCurrentPosition(
      // desiredAccuracy: LocationAccuracy.high,
      // timeLimit: const Duration(seconds: 30),
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 30),
      ),
    );

    final address = await getAddressFromCoordinates(
      position.latitude, position.longitude);

    // Get position with high accuracy
    return LocationEntity(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
      accuracy: position.accuracy,
      address: address,
    );
  }

  // Get position stream for real-time updates
  Stream<Position> getPositionStream() {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    );

    return Geolocator.getPositionStream(locationSettings: locationSettings);
  }

  // Get address from coordinates (reverse geocoding)
  Future<String> getAddressFromCoordinates(
    double latitude, double longitude) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude, longitude);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        return '${place.street}, ${place.locality}, ${place.country}';
      }

      return 'Address not found';
    } catch (e) {
      throw GeocodeException('Failed to get address: $e');
    }
  }

  // Get coordinates from address (forward geocoding)
  Future<LocationEntity> getCoordinatesFromAddress(String address) async {
    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location location = locations[0];
        return LocationEntity(
          latitude: location.latitude,
          longitude: location.longitude,
          timestamp: DateTime.now(),
          accuracy: 0,
          address: address,
        );
      }

      throw GeocodeException('No coordinates found for address');
    } catch (e) {
      throw GeocodeException('Failed to get coordinates: $e');
    }
  }

  // Calculate distance between two points
  double calculateDistance(
    double startLatitude,
    double startLongitude,
    double endLatitude,
    double endLongitude,
  ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
  }

  // Get last known position (cached)
  Future<Position?> getLastKnownPosition() async {
    return await Geolocator.getLastKnownPosition();
  }

  // Open location settings
  Future<bool> openLocationSettings() async {
    return await Geolocator.openLocationSettings();
  }

  // Open app settings
  Future<bool> openAppSettings() async {
    return await Geolocator.openAppSettings();
  }
}
