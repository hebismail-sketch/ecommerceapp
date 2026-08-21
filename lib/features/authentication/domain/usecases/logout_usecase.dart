import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';

/// Use case for user logout
/// Encapsulates the business logic for logout operation
class LogoutUseCase {
  final AuthenticationRepository repository;

  LogoutUseCase({required this.repository});

  /// Executes the logout use case
  /// Returns void on success
  /// Throws exception on failure
  Future<void> call() async {
    return await repository.logout();
  }
}

