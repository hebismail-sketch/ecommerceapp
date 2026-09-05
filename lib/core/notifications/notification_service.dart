import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
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

    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    _messaging.onTokenRefresh.listen(_handleTokenRefresh);

    _initialized = true;
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