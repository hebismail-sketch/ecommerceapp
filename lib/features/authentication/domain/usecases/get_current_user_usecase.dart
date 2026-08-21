import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';
import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';

/// Use case for getting current logged-in user
class GetCurrentUserUseCase {
  final AuthenticationRepository repository;

  GetCurrentUserUseCase({required this.repository});

  /// Executes the get current user use case
  /// Returns UserEntity if user is logged in, null otherwise
  /// Throws exception on failure
  Future<UserEntity?> call() async {
    return await repository.getCurrentUser();
  }
}

