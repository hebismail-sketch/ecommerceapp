import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';


abstract class AuthenticationRepository {
  
  Future<UserEntity> login({
    required String email,
    required String password,
  });


  Future<UserEntity> register({
    required String email,
    required String password,
    required String username,
  });

 
  Future<void> logout();


  Future<UserEntity?> getCurrentUser();


  Future<void> saveDeviceToken(String userId);
}

