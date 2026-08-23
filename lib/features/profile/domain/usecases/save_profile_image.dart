import 'dart:io';
import '../entities/profile_entity.dart';
import '../repositories/profile_repository.dart';

class SaveProfileImage {
  final ProfileRepository repository;

  SaveProfileImage(this.repository);

  Future<ProfileEntity> call({
    required String userId,
    required File? selectedImage,
    required String? currentImageUrl,
  }) {
    return repository.saveProfileImage(
      userId: userId,
      selectedImage: selectedImage,
      currentImageUrl: currentImageUrl,
    );
  }
}