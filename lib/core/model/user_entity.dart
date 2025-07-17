import 'package:floor/floor.dart';

@Entity(tableName: "user_entity")
class UserEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? userId;
  final String? address;
  final String? avatar;

  UserEntity({
    this.id,
    this.userId,
    this.address,
    this.avatar,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) => UserEntity(
    id: json["id"],
    userId: json["userId"],
    address: json["address"],
    avatar: json["avatar"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "address": address,
    "avatar": avatar,
  };

  @override
  String toString() {
    return 'UserEntity(id: $id, userId: $userId, address: $address, avatar: $avatar)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.userId == userId &&
        other.address == address &&
        other.avatar == avatar;
  }

  @override
  int get hashCode {
    return id.hashCode ^
    userId.hashCode ^
    address.hashCode ^
    avatar.hashCode;
  }
}