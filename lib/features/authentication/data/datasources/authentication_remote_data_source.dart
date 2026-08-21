import 'package:ecommerceapp/features/authentication/data/models/user_model.dart';

/// Abstract data source for authentication
/// Defines the contract for remote (Firebase) operations
abstract class AuthenticationRemoteDataSource {
  /// Signs in user with email and password
  /// Returns [UserModel] on success
  /// Throws exception on failure
  Future<UserModel> login({
    required String email,
    required String password,
  });

  /// Registers new user with email, password, and username
  /// Returns [UserModel] on success
  /// Throws exception on failure
  Future<UserModel> register({
    required String email,
    required String password,
    required String username,
  });

  /// Signs out the current user
  Future<void> logout();

  /// Gets current logged-in user data from Firebase
  /// Returns [UserModel] or null if not logged in
  Future<UserModel?> getCurrentUser();

  /// Saves device token to Firebase for push notifications
  Future<void> saveDeviceToken(String userId);
}

