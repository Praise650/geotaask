// You'll also need to define your Location model
class LocationEntity {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final double? accuracy;
  final String? address;

  LocationEntity({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.accuracy,
    this.address,
  });

  @override
  String toString() {
    return 'LocationEntity(lat: $latitude, lng: $longitude,'
        'accuracy: $accuracy, address: $address)';
  }
}
