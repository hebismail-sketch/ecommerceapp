import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';
import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';

/// Use case for user registration
/// Encapsulates the business logic for register operation
class RegisterUseCase {
  final AuthenticationRepository repository;

  RegisterUseCase({required this.repository});

  /// Executes the register use case
  /// Takes email, password, and username as parameters
  /// Returns UserEntity on success
  /// Throws exception on failure
  Future<UserEntity> call({
    required String email,
    required String password,
    required String username,
  }) async {
    return await repository.register(
      email: email,
      password: password,
      username: username,
    );
  }
}

