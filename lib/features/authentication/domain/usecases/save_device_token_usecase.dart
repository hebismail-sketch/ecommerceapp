import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';

/// Use case for saving device token
/// Used for push notifications
class SaveDeviceTokenUseCase {
  final AuthenticationRepository repository;

  SaveDeviceTokenUseCase({required this.repository});

  /// Executes the save device token use case
  /// Takes userId as parameter
  /// Returns void on success
  /// Throws exception on failure
  Future<void> call({required String userId}) async {
    return await repository.saveDeviceToken(userId);
  }
}

