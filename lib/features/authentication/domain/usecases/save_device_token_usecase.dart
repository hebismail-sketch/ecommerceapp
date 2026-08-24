import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';


class SaveDeviceTokenUseCase {
  final AuthenticationRepository repository;

  SaveDeviceTokenUseCase({required this.repository});

 
  Future<void> call({required String userId}) async {
    return await repository.saveDeviceToken(userId);
  }
}

