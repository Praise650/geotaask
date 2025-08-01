// You'll also need to define your Location model
class LocationEntity {
  final double latitude;
  final double longitude;
  final DateTime? timestamp;
  final double? accuracy;
  final String? address;

  LocationEntity({
    required this.latitude,
    required this.longitude,
    this.timestamp,
    this.accuracy,
    this.address,
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
}
