import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class NotificationApi {
  NotificationApi._();

  static const _workerUrl =
      'https://ecommerce-notificationsf.esmailheba31.workers.dev';

  static Future<void> notify({
    required String action,
    required String title,
    required String body,
    String? recipientUserId,
    Map<String, String> data = const {},
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      final idToken = await user?.getIdToken();
      if (idToken == null || idToken.isEmpty) return;

      await http.post(
        Uri.parse(_workerUrl),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'action': action,
          'title': title,
          'body': body,
          'recipientUserId': recipientUserId,
          'data': data,
        }),
      );
    } catch (_) {
      // Notification failure must not cancel the completed business action.
    }
  }
}