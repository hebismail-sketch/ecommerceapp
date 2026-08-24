import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';


class LogoutUseCase {
  final AuthenticationRepository repository;

  LogoutUseCase({required this.repository});

  Future<void> call() async {
    return await repository.logout();
  }
}

