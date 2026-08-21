import 'package:ecommerceapp/features/authentication/data/datasources/authentication_remote_data_source.dart';
import 'package:ecommerceapp/features/authentication/domain/entities/user_entity.dart';
import 'package:ecommerceapp/features/authentication/domain/repositories/authentication_repository.dart';

/// Implementation of [AuthenticationRepository]
/// This class acts as a bridge between domain and data layers
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthenticationRemoteDataSource remoteDataSource;

  AuthenticationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> login({
    required String email,
    required String password,
  }) async {
    // Call remote data source and convert model to entity
    final userModel = await remoteDataSource.login(
      email: email,
      password: password,
    );
    return userModel.toEntity();
  }

  @override
  Future<UserEntity> register({
    required String email,
    required String password,
    required String username,
  }) async {
    // Call remote data source and convert model to entity
    final userModel = await remoteDataSource.register(
      email: email,
      password: password,
      username: username,
    );
    return userModel.toEntity();
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    final userModel = await remoteDataSource.getCurrentUser();
    return userModel?.toEntity();
  }

  @override
  Future<void> saveDeviceToken(String userId) async {
    await remoteDataSource.saveDeviceToken(userId);
  }
}

