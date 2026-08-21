import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';

/// Abstract repository that defines authentication operations
/// This is a contract that data layer must implement
abstract class AuthenticationRepository {
  /// Signs in user with email and password
  /// Returns [UserEntity] on success
  /// Throws exception on failure
  Future<UserEntity> login({
    required String email,
    required String password,
  });

  /// Registers new user with email, password, and username
  /// Returns [UserEntity] on success
  /// Throws exception on failure
  Future<UserEntity> register({
    required String email,
    required String password,
    required String username,
  });

  /// Signs out the current user
  Future<void> logout();

  /// Gets current logged-in user
  /// Returns [UserEntity] or null if not logged in
  Future<UserEntity?> getCurrentUser();

  /// Saves device token for push notifications
  Future<void> saveDeviceToken(String userId);
}

