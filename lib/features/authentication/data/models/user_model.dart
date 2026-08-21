import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';

/// UserModel is a data layer representation of UserEntity
/// It contains methods to convert to/from JSON and Entity
class UserModel {
  final String uid;
  final String email;
  final String username;
  final String role;

  const UserModel({
    required this.uid,
    required this.email,
    required this.username,
    required this.role,
  });

  /// Convert JSON (from Firebase) to UserModel
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'] as String? ?? '',
      email: json['email'] as String? ?? '',
      username: json['username'] as String? ?? '',
      role: json['role'] as String? ?? 'user',
    );
  }

  /// Convert UserModel to JSON (for Firebase)
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'role': role,
    };
  }

  /// Convert UserModel to UserEntity (domain layer)
  UserEntity toEntity() {
    return UserEntity(
      uid: uid,
      email: email,
      username: username,
      role: role,
    );
  }
}

