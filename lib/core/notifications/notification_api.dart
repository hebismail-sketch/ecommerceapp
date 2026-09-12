import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
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
      if (idToken == null || idToken.isEmpty) {
        debugPrint('[NotificationApi] No user logged in or idToken is null.');
        return;
      }

      final payload = {
        'action': action,
        'title': title,
        'body': body,
        'recipientUserId': recipientUserId,
        'data': data,
      };

      debugPrint('[NotificationApi] Sending notification payload: ${jsonEncode(payload)}');

      final response = await http.post(
        Uri.parse(_workerUrl),
        headers: {
          'Authorization': 'Bearer $idToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      debugPrint('[NotificationApi] Response status: ${response.statusCode}, body: ${response.body}');
    } catch (e) {
      debugPrint('[NotificationApi] Notification sending error: $e');
    }
  }
}