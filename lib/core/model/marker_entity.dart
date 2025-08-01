import 'package:floor/floor.dart';

import '../../utils/helpers.dart';
import '../enums/marker_status.dart';
import 'location_entity.dart';

@Entity(tableName: "tag_location_entity")
class MarkerEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final double? radius;
  final double? latitude;
  final double? longitude;
  final String? markerId;
  final String? title;
  final String? description;
  final String? createdAt;
  final int? enabled;
  final MarkerStatus status;

  MarkerEntity({
    this.id,
    this.radius = 100.0,
    this.latitude,
    this.longitude,
    this.markerId,
    this.title,
    this.description,
    this.createdAt,
    this.enabled = 1,
    this.status = MarkerStatus.inactive,
  });

  MarkerEntity copyWith({
    int? id,
    double? radius,
    double? latitude,
    double? longitude,
    String? markerId,
    String? title,
    String? description,
    String? createdAt,
    int? enabled,
    MarkerStatus? status,
  }) {
    return MarkerEntity(
      id: id ?? this.id,
      radius: radius ?? this.radius,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      markerId: markerId ?? this.markerId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      enabled: enabled ?? this.enabled,
      status: status ?? this.status,
    );
  }

  void disable() {
    copyWith(status: MarkerStatus.inactive, enabled: 0);
  }

  void markComplete() {
    copyWith(status: MarkerStatus.completed, enabled: 0);
  }

  bool isEnabled() {
    return enabled == 1;
  }

  bool isActive() {
    return status == MarkerStatus.active;
  }

  bool isComplete() {
    return status == MarkerStatus.completed;
  }

  bool isInRange(LocationEntity currentLocation) {
    final calculatedDistance = Helpers.calcDistanceBetweenInM(
      currentLocation,
      LocationEntity(latitude: latitude!, longitude: longitude!),
    );
    return calculatedDistance <= 500;
  }

  factory MarkerEntity.from(Map<String, dynamic> json) => MarkerEntity(
    id: json["id"],
    radius: json["radius"],
    latitude: json["latitude"]?.toDouble(),
    longitude: json["longitude"]?.toDouble(),
    markerId: json["markerId"],
    title: json["title"],
    description: json["description"],
    createdAt: json["created_at"],
    enabled: json["enabled"] ?? 1,
    status: MarkerStatus.values.firstWhere(
      (e) => e.name == json["status"],
      orElse: () => MarkerStatus.inactive,
    ),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "radius": radius,
    "latitude": latitude,
    "longitude": longitude,
    "markerId": markerId,
    "title": title,
    "description": description,
    "created_at": createdAt,
    "enabled": enabled,
    "status": status.name,
  };
}
