import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';
import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';

/// Use case for user login
/// Encapsulates the business logic for login operation
class LoginUseCase {
  final AuthenticationRepository repository;

  LoginUseCase({required this.repository});

  /// Executes the login use case
  /// Takes email and password as parameters
  /// Returns UserEntity on success
  /// Throws exception on failure
  Future<UserEntity> call({
    required String email,
    required String password,
  }) async {
    return await repository.login(
      email: email,
      password: password,
    );
  }
}

