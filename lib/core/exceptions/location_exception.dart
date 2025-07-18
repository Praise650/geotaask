// Custom exceptions
class LocationServiceDisabledException implements Exception {
  final String message;
  LocationServiceDisabledException(this.message);

  @override
  String toString() => message;
}

class LocationPermissionDeniedException implements Exception {
  final String message;
  LocationPermissionDeniedException(this.message);

  @override
  String toString() => message;
}

class GeocodeException implements Exception {
  final String message;
  GeocodeException(this.message);

  @override
  String toString() => message;
}
