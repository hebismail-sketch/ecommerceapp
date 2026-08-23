import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/services/cloudinary_service.dart';
import '../../domain/entities/profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<ProfileEntity> getProfile(String userId);
  Future<ProfileEntity> saveProfileImage({
    required String userId,
    required File? selectedImage,
    required String? currentImageUrl,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final FirebaseFirestore firestore;

  ProfileRemoteDataSourceImpl({required this.firestore});

  DocumentReference<Map<String, dynamic>> _userDocument(String userId) {
    return firestore.collection('users').doc(userId);
  }

  @override
  Future<ProfileEntity> getProfile(String userId) async {
    final document = await _userDocument(userId).get();
    final imageUrl = document.data()?['profileImageUrl'];
    return ProfileEntity(
      imageUrl: imageUrl is String && imageUrl.isNotEmpty ? imageUrl : null,
    );
  }

  @override
  Future<ProfileEntity> saveProfileImage({
    required String userId,
    required File? selectedImage,
    required String? currentImageUrl,
  }) async {
    var imageUrl = currentImageUrl;

    if (selectedImage != null) {
      imageUrl = await CloudinaryService.uploadProfileImage(selectedImage);
    }

    await _userDocument(userId).update({
      'profileImageUrl': imageUrl ?? FieldValue.delete(),
    });

    return ProfileEntity(imageUrl: imageUrl);
  }
}