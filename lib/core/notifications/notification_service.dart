import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:onesignal_flutter/onesignal_flutter.dart';

/// Central notification manager for Firebase and OneSignal.
/// It handles initialize, permission, user identification, and app-triggered push events.
class NotificationService {
  static const String _oneSignalAppId =
      'ef94b6f5-27e2-4f82-808a-815c7be086c6';

  static final FirebaseMessaging _messaging =
      FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'general_notifications',
    'General Notifications',
    description: 'General app notifications',
    importance: Importance.max,
  );

  static bool _initialized = false;

  /// Initializes local notifications, Firebase messaging, and OneSignal.
  /// This is called once during application startup.
  static Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const settings = InitializationSettings(
      android: androidSettings,
    );

    await _notifications.initialize(
      settings: settings,
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    await androidPlugin?.createNotificationChannel(_channel);

    await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    OneSignal.initialize(_oneSignalAppId);

    OneSignal.Notifications.addForegroundWillDisplayListener((event) async {
      final title = event.notification.title ?? '';
      final body = event.notification.body ?? '';

      if (title.isNotEmpty || body.isNotEmpty) {
        await showNotification(
          title: title,
          body: body,
          data: {
            'type': 'onesignal',
            'notification_id': event.notification.notificationId ?? '',
          },
        );
      }
    });

    final hasPermission = await OneSignal.Notifications.requestPermission(true);

    if (hasPermission) {
      debugPrint('OneSignal notification permission granted.');
    } else {
      debugPrint('OneSignal notification permission denied.');
    }

    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    if (userId.isNotEmpty) {
      await identifyUser(userId);
    }

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    _messaging.onTokenRefresh.listen(_handleTokenRefresh);

    _initialized = true;
  }

  /// Bind the Firebase user id to OneSignal and tag the role for segmented pushes.
  static Future<void> identifyUser(
    String userId, {
    String role = AppConstants.userRole,
  }) async {
    if (userId.trim().isEmpty) return;

    OneSignal.login(userId);
    OneSignal.User.addAlias('firebase_uid', userId);
    OneSignal.User.addAlias('user_id', userId);
    OneSignal.User.addAlias('role', role);
  }

  /// Sends a direct notification to a specific user via OneSignal API.
  static Future<void> sendToUser({
    required String userId,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    if (userId.trim().isEmpty) return;

    final apiKey = const String.fromEnvironment(
      'ONE_SIGNAL_REST_API_KEY',
      defaultValue: '',
    );

    if (apiKey.isEmpty) {
      debugPrint('OneSignal REST API key is missing.');
      return;
    }

    final response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $apiKey',
      },
      body: jsonEncode({
        'app_id': _oneSignalAppId,
        'include_aliases': {
          'external_id': [userId],
        },
        'headings': {
          'en': title,
          'ar': title,
        },
        'contents': {
          'en': body,
          'ar': body,
        },
        'data': data ?? {},
      }),
    );

    if (response.statusCode >= 400) {
      debugPrint('OneSignal user push failed: ${response.body}');
    }
  }

  /// Sends a notification to all users matching a role tag such as admin or user.
  static Future<void> sendToRole({
    required String role,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    final apiKey = const String.fromEnvironment(
      'ONE_SIGNAL_REST_API_KEY',
      defaultValue: '',
    );

    if (apiKey.isEmpty) {
      debugPrint('OneSignal REST API key is missing.');
      return;
    }

    final response = await http.post(
      Uri.parse('https://onesignal.com/api/v1/notifications'),
      headers: {
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Basic $apiKey',
      },
      body: jsonEncode({
        'app_id': _oneSignalAppId,
        'filters': [
          {
            'field': 'tag',
            'key': 'role',
            'relation': '=',
            'value': role,
          },
        ],
        'headings': {
          'en': title,
          'ar': title,
        },
        'contents': {
          'en': body,
          'ar': body,
        },
        'data': data ?? {},
      }),
    );

    if (response.statusCode >= 400) {
      debugPrint('OneSignal role push failed: ${response.body}');
    }
  }

  static Future<void> saveToken(String userId) async {
    final token = await _messaging.getToken();

    if (token == null || token.isEmpty) return;

    await _saveTokenForUser(
      userId: userId,
      token: token,
    );
  }

  static Future<void> _handleTokenRefresh(String token) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null || token.isEmpty) return;

    await _saveTokenForUser(
      userId: userId,
      token: token,
    );
  }

  static Future<void> _saveTokenForUser({
    required String userId,
    required String token,
  }) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .set(
      {
        'fcmToken': token,
        'notificationsEnabled': true,
      },
      SetOptions(merge: true),
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    await _notifications.show(
      id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title: title,
      body: body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _channel.id,
          _channel.name,
          channelDescription: _channel.description,
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: data == null ? null : jsonEncode(data),
    );
  }

  static Future<void> _handleForegroundMessage(
    RemoteMessage message,
  ) async {
    final title =
        message.notification?.title ??
        message.data['title']?.toString() ??
        '';

    final body =
        message.notification?.body ??
        message.data['body']?.toString() ??
        '';

    if (title.isEmpty && body.isEmpty) return;

    await showNotification(
      title: title,
      body: body,
      data: message.data,
    );
  }

  static void _handleNotificationTap(
    NotificationResponse response,
  ) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) return;

    try {
      final decodedPayload = jsonDecode(payload);

      if (decodedPayload is Map<String, dynamic>) {
        debugPrint('Notification tapped: $decodedPayload');
      }
    } catch (error) {
      debugPrint('Invalid notification payload: $error');
    }
  }
}