import 'dart:io';
import '../entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<ProfileEntity> getProfile(String userId);
  Future<ProfileEntity> saveProfileImage({
    required String userId,
    required File? selectedImage,
    required String? currentImageUrl,
  });
}