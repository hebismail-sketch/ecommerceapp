import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import 'package:ecommerceapp/core/constants/cloudinary_constants.dart';

class CloudinaryService {
  CloudinaryService._();

  static Future<String> uploadProfileImage(File imageFile) async {
    final uri = Uri.parse(
      'https://api.cloudinary.com/v1_1/'
          '${CloudinaryConstants.cloudName}/image/upload',
    );

    final request = http.MultipartRequest('POST', uri);

    request.fields['upload_preset'] =
        CloudinaryConstants.uploadPreset;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ),
    );

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode != 200) {
      throw Exception('Failed to upload image');
    }

    final data = jsonDecode(responseBody);

    return data['secure_url'] as String;
  }
}