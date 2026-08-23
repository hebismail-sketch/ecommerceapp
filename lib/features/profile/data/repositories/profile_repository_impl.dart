import 'dart:io';
import '../../domain/entities/profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProfileEntity> getProfile(String userId) {
    return remoteDataSource.getProfile(userId);
  }

  @override
  Future<ProfileEntity> saveProfileImage({
    required String userId,
    required File? selectedImage,
    required String? currentImageUrl,
  }) {
    return remoteDataSource.saveProfileImage(
      userId: userId,
      selectedImage: selectedImage,
      currentImageUrl: currentImageUrl,
    );
  }
}