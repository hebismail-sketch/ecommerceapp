import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';
import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';


class LoginUseCase {
  final AuthenticationRepository repository;

  LoginUseCase({required this.repository});

  
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

