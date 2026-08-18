import 'dart:io';

import 'package:ecommerceapp/features/cars/services/image_service.dart';

class ImageRepository {
  final ImageService _imageService = ImageService();

  Future<String> uploadImage(File image) async {
    return await _imageService.uploadImage(image);
  }
}
