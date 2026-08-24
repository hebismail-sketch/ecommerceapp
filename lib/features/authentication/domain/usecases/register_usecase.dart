import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';
import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';

class RegisterUseCase {
  final AuthenticationRepository repository;

  RegisterUseCase({required this.repository});

  
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

