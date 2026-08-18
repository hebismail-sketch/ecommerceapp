import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    this.size = 30,
    this.imageUrl,
    this.onTap,
  });

  final double size;
  final String? imageUrl;
  final VoidCallback? onTap;

  Future<String?> _getProfileImageUrl() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    final document = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final data = document.data();

    if (data == null) {
      return null;
    }

    final savedImageUrl = data['profileImageUrl'];

    if (savedImageUrl is String && savedImageUrl.isNotEmpty) {
      return savedImageUrl;
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: FutureBuilder<String?>(
        future: _getProfileImageUrl(),
        builder: (context, snapshot) {
          final savedImageUrl = snapshot.data;

          final finalImageUrl =
          imageUrl != null && imageUrl!.isNotEmpty
              ? imageUrl
              : savedImageUrl;

          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircleAvatar(
              radius: size / 2,
              child: SizedBox(
                width: size * 0.4,
                height: size * 0.4,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                ),
              ),
            );
          }

          if (finalImageUrl != null && finalImageUrl.isNotEmpty) {
            return ClipOval(
              child: SizedBox(
                width: size,
                height: size,
                child: Image.network(
                  finalImageUrl,
                  fit: BoxFit.contain,
                ),
              ),
            );
          }

          return CircleAvatar(
            radius: size / 2,
            child: Icon(
              Icons.person,
              size: size * 0.55,
            ),
          );
        },
      ),
    );
  }
}