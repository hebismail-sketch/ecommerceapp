// File: lib/features/chat/presentation/widgets/user_avatar_widget.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

class UserAvatarWidget extends StatelessWidget {
  final String userId;
  final String fallbackName;
  final double radius;
  final VoidCallback? onTap;

  const UserAvatarWidget({
    super.key,
    required this.userId,
    required this.fallbackName,
    this.radius = 24,
    this.onTap,
  });

  Future<Map<String, dynamic>?> _getUserData() async {
    if (userId.isEmpty) return null;
    try {
      final doc = await FirebaseFirestore.instance
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      return doc.data();
    } catch (_) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    Widget buildPlaceholder(String name) {
      final initial = name.isNotEmpty ? name[0].toUpperCase() : 'U';
      return CircleAvatar(
        radius: radius,
        backgroundColor: isDark ? Colors.red.shade900 : Colors.red.shade100,
        child: Text(
          initial,
          style: TextStyle(
            fontSize: radius * 0.8,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.red.shade200 : Colors.red.shade800,
          ),
        ),
      );
    }

    final avatar = FutureBuilder<Map<String, dynamic>?>(
      future: _getUserData(),
      builder: (context, snapshot) {
        final data = snapshot.data;
        final imageUrl = data?['profileImageUrl'] as String?;
        final username = (data?['username'] as String?)?.isNotEmpty == true
            ? data!['username'] as String
            : fallbackName;

        if (imageUrl != null && imageUrl.isNotEmpty) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(radius),
            child: Image.network(
              imageUrl,
              width: radius * 2,
              height: radius * 2,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => buildPlaceholder(username),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return buildPlaceholder(username);
              },
            ),
          );
        }

        return buildPlaceholder(username);
      },
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatar,
      );
    }

    return avatar;
  }
}
