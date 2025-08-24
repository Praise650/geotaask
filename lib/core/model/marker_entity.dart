import 'package:floor/floor.dart';

import '../../utils/helpers.dart';
import '../enums/marker_status.dart';
import 'location_entity.dart';

// String-based converter (if you prefer ISO format)
class DateTimeStringConverter extends TypeConverter<DateTime?, String?> {
  @override
  DateTime? decode(String? databaseValue) {
    if (databaseValue == null) return null;
    return DateTime.parse(databaseValue);
  }

  @override
  String? encode(DateTime? value) {
    return value?.toIso8601String();
  }
}

class BoolConverter extends TypeConverter<bool, int> {
  @override
  int encode(bool value) {
    return value ? 1 : 0;
  }

  @override
  bool decode(int databaseValue) {
    return databaseValue == 1;
  }
}

@Entity(tableName: "geofences")
class MarkerEntity {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final double? radius;
  final double? latitude;
  final double? longitude;
  final String? markerId;
  final String? title;
  final String? description;
  @TypeConverters([BoolConverter])
  final bool notified;
  @TypeConverters([MarkerStatusConverter])
  final MarkerStatus status;
  @TypeConverters([DateTimeStringConverter])
  final DateTime? createdAt;
  @TypeConverters([DateTimeStringConverter])
  final DateTime? startsAt;
  @TypeConverters([DateTimeStringConverter])
  final DateTime? endsAt;

  MarkerEntity({
    this.id,
    this.radius = 100.0,
    this.latitude,
    this.longitude,
    this.markerId,
    this.title,
    this.description,
    this.notified = false,
    this.status = MarkerStatus.enabled,
    this.createdAt,
    this.startsAt,
    this.endsAt,
  });

  MarkerEntity copyWith({
    int? id,
    double? radius,
    double? latitude,
    double? longitude,
    String? markerId,
    String? title,
    String? description,
    bool? notified,
    MarkerStatus? status,
    DateTime? createdAt,
    DateTime? startsAt,
    DateTime? endsAt,
  }) {
    return MarkerEntity(
      id: id ?? this.id,
      radius: radius ?? this.radius,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      markerId: markerId ?? this.markerId,
      title: title ?? this.title,
      description: description ?? this.description,
      notified: notified ?? this.notified,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      startsAt: startsAt ?? this.startsAt,
      endsAt: endsAt ?? this.endsAt,
    );
  }
  
  // void mute() {
  //   copyWith(
  //     status: MarkerStatus.muted,
  //     notified: true,
  //   );
  // }
  //
  // void unMute() {
  //   copyWith(
  //     status: MarkerStatus.enabled,
  //     notified: false,
  //   );
  // }
  //
  // void snooze() {
  //   copyWith(
  //     status: MarkerStatus.enabled,
  //     notified: false,
  //   );
  // }
  //
  // void markComplete() {
  //   copyWith(
  //     status: MarkerStatus.completed,
  //     notified: true,
  //   );
  // }

  // Change these methods to return the updated instance
  MarkerEntity restart() {
    return copyWith(
      status: MarkerStatus.enabled,
      notified: false,
    );
  }

  MarkerEntity mute() {
    return copyWith(
      status: MarkerStatus.muted,
      notified: true,
    );
  }

  MarkerEntity unMute() {
    return copyWith(
      status: MarkerStatus.enabled,
      notified: false,
    );
  }

  MarkerEntity snooze() {
    return copyWith(
      status: MarkerStatus.enabled,
      notified: false,
    );
  }

  MarkerEntity markComplete() {
    return copyWith(
      status: MarkerStatus.completed,
      notified: true,
    );
  }

  bool isEnabled() {
    return status == MarkerStatus.enabled;
  }

  bool isMuted() {
    return status == MarkerStatus.muted;
  }

  bool isCompleted() {
    return status == MarkerStatus.completed;
  }

  // for consistency
  bool isNotified() {
    return notified;
  }

  // for consistency
  bool isNotNotified() {
    return !notified;
  }

  bool isActive() {
    return isEnabled() &&
        isNotExpired() &&
        isNotNotified();
  }

  bool hasBegun() {
    return startsAt == null ||
        startsAt!.isBefore(DateTime.now());
  }

  bool isExpired() {
    return endsAt != null &&
        endsAt!.isBefore(DateTime.now());
  }

  bool isNotExpired() {
    return !isExpired();
  }

  bool isInRange(LocationEntity currentLocation) {
    final calculatedDistance = Helpers.calcDistanceBetweenInM(
      currentLocation.latitude,currentLocation.longitude,
      latitude!, longitude!);
    // return calculatedDistance <= (radius ?? 500.0);
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
    notified: json['notified'],
    status: MarkerStatus.values.firstWhere(
      (e) => e.name == json["status"],
      orElse: () => MarkerStatus.enabled,
    ),
    createdAt: json["createdAt"] != null ? DateTime.parse(json["createdAt"]) : null,
    startsAt: json['startsAt'] != null ? DateTime.parse(json['startsAt']) : null,
    endsAt: json['endsAt'] != null ? DateTime.parse(json['endsAt']) : null,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "radius": radius,
    "latitude": latitude,
    "longitude": longitude,
    "markerId": markerId,
    "title": title,
    "description": description,
    "status": status.name,
    "notified": notified,
    "createdAt": createdAt?.toIso8601String(),
    'startsAt': startsAt?.toIso8601String(),
    'endsAt': endsAt?.toIso8601String(),
  };
}
