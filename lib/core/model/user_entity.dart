import 'package:floor/floor.dart';

@Entity(tableName: "user_entity")
class UserEntity {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? userId;
  final String? address;
  final String? avatar;
  final String? userName;
  final String? bio;

  UserEntity({
    this.id,
    this.userId,
    this.address,
    this.avatar,
    this.userName,
    this.bio,
  });

  factory UserEntity.fromJson(Map<String, dynamic> json) {
    return UserEntity(
      id: json["id"],
      userId: json["userId"] as String?,
      address: json["address"] as String?,
      avatar: json["avatar"] as String?,
      userName: json['userName'] as String?,
      bio: json["bio"] as String?
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "userId": userId,
    "address": address,
    "avatar": avatar,
    "userName": userName,
    "bio": bio,
  };

  @override
  String toString() {
    return 'UserEntity(id: $id, userId: $userId, address: $address, '
        'avatar: $avatar, userName: $userName, bio: $bio)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserEntity &&
        other.id == id &&
        other.userId == userId &&
        other.address == address &&
        other.avatar == avatar &&
        other.userName == userName &&
        other.bio == bio;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        address.hashCode ^
        avatar.hashCode ^
        userName.hashCode ^
        bio.hashCode;
  }
}
