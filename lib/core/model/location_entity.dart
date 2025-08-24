// You'll also need to define your Location model
import 'package:geolocator/geolocator.dart' show Position;

class LocationEntity {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;
  final double? accuracy;
  final String? address;
  final double? heading;
  final double? speed;
  final double? altitude;
  final double? altitudeAccuracy;

  LocationEntity({
    required this.latitude,
    required this.longitude,
    this.timestamp,
    this.accuracy,
    this.address,
    this.heading,
    this.speed,
    this.altitude,
    this.altitudeAccuracy,
  });

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(
      longitude: json["longitude"],
      latitude: json["latitude"],
      timestamp: DateTime.parse(json['timestamp']),
      address: json['address'],
      accuracy: json['accuracy'],
    );
  }

  @override
  String toString() {
    return 'LocationEntity(lat: $latitude, lng: $longitude,'
        'accuracy: $accuracy, address: $address)';
  }

  /// Convert Position to LocationEntity
  factory LocationEntity.positionToLocationEntity(
      Position position, {String? address}) {
    return LocationEntity(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: position.timestamp,
      address: address,
      heading: position.heading,
      speed: position.speed,
      accuracy: position.accuracy,
      altitude: position.altitude,
      altitudeAccuracy: position.altitudeAccuracy,
    );
  }
}
