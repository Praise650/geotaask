// import "package:json_annotation/json_annotation.dart";
//
// import "../location_entity.dart";
//
// part 'place_entity.g.dart';
//
// @JsonSerializable()
// class PlaceEntity {
//   final String name;
//   final String? vicinity;  // Address
//   @JsonKey(name: 'place_id')
//   final String placeId;
//   final Geometry geometry;
//   @JsonKey(name: 'user_ratings_total')
//   final int? userRatingsTotal;
//   final double? rating;
//
//   PlaceEntity({
//     required this.name,
//     this.vicinity,
//     required this.placeId,
//     required this.geometry,
//     this.userRatingsTotal,
//     this.rating,
//   });
//
//   factory PlaceEntity.fromJson(Map<String, dynamic> json) => _$PlaceResultFromJson(json);
//   Map<String, dynamic> toJson() => _$PlaceResultToJson(this);
// }
//
// @JsonSerializable()
// class Geometry {
//   final LocationEntity location;
//
//   Geometry({required this.location});
//
//   factory Geometry.fromJson(Map<String, dynamic> json) => _$GeometryFromJson(json);
//   Map<String, dynamic> toJson() => _$GeometryToJson(this);
// }
//
// // @JsonSerializable()
// // class Location {
// //   final double lat;
// //   final double lng;
// //
// //   Location({required this.lat, required this.lng});
// //
// //   factory Location.fromJson(Map<String, dynamic> json) => _$LocationFromJson(json);
// //   Map<String, dynamic> toJson() => _$LocationToJson(this);
// // }


// models/place.dart
import '../../../utils/helpers.dart';
import '../location_entity.dart';

class PlaceEntity {
  final String placeId;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final String? photoReference;
  final bool isOpen;
  final List<String> types;

  final String? phoneNumber;
  final String? website;

  PlaceEntity({
    required this.placeId,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    this.photoReference,
    required this.isOpen,
    required this.types,

    this.phoneNumber,
    this.website,
  });

  factory PlaceEntity.fromJson(Map<String, dynamic> json) {
    final geometry = json['geometry'];
    final location = geometry['location'];

    return PlaceEntity(
      placeId: json['place_id'] ?? '',
      name: json['name'] ?? '',
      address: json['vicinity'] ?? json['formatted_address'] ?? '',
      latitude: location['lat']?.toDouble() ?? 0.0,
      longitude: location['lng']?.toDouble() ?? 0.0,
      rating: json['rating']?.toDouble() ?? 0.0,
      photoReference: json['photos']?[0]?['photo_reference'],
      isOpen: json['opening_hours']?['open_now'] ?? false,
      types: List<String>.from(json['types'] ?? []),

      phoneNumber: json['formatted_phone_number'],
      website: json['website'],
    );
  }

  double distanceFromUser(double userLat, double userLng) {
    final distanceInMeter = Helpers.calcDistanceBetweenInM(userLat, userLng, latitude, longitude);
    return distanceInMeter.toDouble();
  }

  // Convert to LocationEntity for your existing code
  LocationEntity toLocationEntity() {
    return LocationEntity(
      latitude: latitude,
      longitude: longitude,
      address: address,
      // name: name,
      // Add other required fields based on your LocationEntity structure
    );
  }
}