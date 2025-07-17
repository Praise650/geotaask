import 'package:floor/floor.dart';

import '../enums/marker_status.dart';

@Entity(tableName: "tag_location_entity")
class MarkerEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final double? radius;
  final double? latitude;
  final double? longitude;
  final String? markerId;
  final String? title;
  final String? description;
  final String? createdAt;
  final bool isActive;
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
    this.isActive = false,
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
    bool? isActive,
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
      isActive: isActive ?? this.isActive,
      status: status ?? this.status,
    );
  }

  factory MarkerEntity.from(Map<String, dynamic> json) =>
      MarkerEntity(
        id: json["id"],
        radius: json["radius"],
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        markerId: json["markerId"],
        title: json["title"],
        description: json["description"],
        createdAt: json["created_at"],
        isActive: json["isActive"] ?? false,
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
    "isActive": isActive,
    "status": status.name,
  };
}
