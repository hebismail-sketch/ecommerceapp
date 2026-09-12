import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/features/chat/data/models/conversation_model.dart';
import 'package:ecommerceapp/features/chat/presentation/pages/admin_chat_detail_page.dart';
import 'package:ecommerceapp/features/chat/presentation/pages/admin_conversations_page.dart';
import 'package:ecommerceapp/features/chat/presentation/pages/user_chat_page.dart';
import 'package:ecommerceapp/features/main/presentation/pages/main_screen.dart';
import 'package:ecommerceapp/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ecommerceapp/features/orders/presentation/pages/order_screen.dart';
import 'package:ecommerceapp/features/products/data/models/product_model.dart';
import 'package:ecommerceapp/features/products/presentation/pages/product_details_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Central notification manager for Firebase push and local app notifications.
/// It handles initialization, token storage, and app-triggered foreground notifications.
class NotificationService {
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel = AndroidNotificationChannel(
    'general_notifications',
    'General Notifications',
    description: 'General app notifications',
    importance: Importance.max,
  );

  static bool _initialized = false;
  static bool _localNotificationsInitialized = false;

  /// Initializes local notifications and Firebase messaging.
  /// This is called once during application startup.
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      await initializeLocalNotifications();
    } catch (e) {
      debugPrint('initializeLocalNotifications failed: $e');
    }

    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );
    } catch (e) {
      debugPrint('requestPermission failed: $e');
    }

    try {
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);
      _messaging.onTokenRefresh.listen(_handleTokenRefresh);

      // Listen for notification clicks when the app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint('[NotificationService] onMessageOpenedApp tapped: ${message.data}');
        handleNotificationData(message.data);
      });

      // Listen to auth state changes to auto-save and refresh token immediately
      FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          saveToken(user.uid);
        }
      });

      // Check if the app was launched by tapping a notification while terminated
      checkInitialNotification();
    } catch (e) {
      debugPrint('Notification listeners setup failed: $e');
    }

    _initialized = true;
  }

  /// Bind the Firebase user id to the app profile and keep the role on the user document.
  static Future<void> identifyUser(
    String userId, {
    String role = AppConstants.userRole,
  }) async {
    if (userId.trim().isEmpty) return;

    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'role': role,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('NotificationService.identifyUser failed: $e');
    }
  }

  static Future<void> saveToken(String userId) async {
    try {
      final token = await _messaging.getToken();
      debugPrint('FCM Token for user $userId: $token');

      if (token == null || token.isEmpty) return;

      await _saveTokenForUser(userId: userId, token: token);
    } catch (e) {
      debugPrint('NotificationService.saveToken failed: $e');
    }
  }

  static Future<void> _handleTokenRefresh(String token) async {
    try {
      final userId = FirebaseAuth.instance.currentUser?.uid;

      if (userId == null || token.isEmpty) return;

      await _saveTokenForUser(userId: userId, token: token);
    } catch (e) {
      debugPrint('NotificationService._handleTokenRefresh failed: $e');
    }
  }

  static Future<void> _saveTokenForUser({
    required String userId,
    required String token,
  }) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
        'notificationsEnabled': true,
      }, SetOptions(merge: true));
      debugPrint('FCM token successfully saved to Firestore for user: $userId');
    } catch (e) {
      debugPrint('NotificationService._saveTokenForUser failed: $e');
    }
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
          playSound: true,
          enableVibration: true,
          icon: '@mipmap/ic_launcher',
        ),
      ),
      payload: data == null ? null : jsonEncode(data),
    );
  }

  static Future<void> initializeLocalNotifications() async {
    if (_localNotificationsInitialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    await _notifications.initialize(
      settings: const InitializationSettings(android: androidSettings),
      onDidReceiveNotificationResponse: _handleNotificationTap,
    );

    final androidPlugin = _notifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    await androidPlugin?.createNotificationChannel(_channel);
    _localNotificationsInitialized = true;
  }

  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    final title =
        message.notification?.title ?? message.data['title']?.toString() ?? '';

    final body =
        message.notification?.body ?? message.data['body']?.toString() ?? '';

    if (title.isEmpty && body.isEmpty) return;

    await showNotification(title: title, body: body, data: message.data);
  }

  static void _handleNotificationTap(NotificationResponse response) {
    final payload = response.payload;

    if (payload == null || payload.isEmpty) return;

    try {
      final decodedPayload = jsonDecode(payload);

      if (decodedPayload is Map<String, dynamic>) {
        debugPrint('Notification tapped: $decodedPayload');
        handleNotificationData(decodedPayload);
      }
    } catch (error) {
      debugPrint('Invalid notification payload: $error');
    }
  }

  /// Checks if the app was launched from a terminated state via a notification.
  static Future<void> checkInitialNotification() async {
    try {
      final initialMessage = await _messaging.getInitialMessage();
      if (initialMessage != null && initialMessage.data.isNotEmpty) {
        debugPrint('[NotificationService] Initial FCM message: ${initialMessage.data}');
        handleNotificationData(initialMessage.data);
        return;
      }

      final launchDetails =
          await _notifications.getNotificationAppLaunchDetails();
      if (launchDetails != null &&
          launchDetails.didNotificationLaunchApp &&
          launchDetails.notificationResponse?.payload != null) {
        final payload = launchDetails.notificationResponse!.payload!;
        final decoded = jsonDecode(payload);
        if (decoded is Map<String, dynamic>) {
          debugPrint('[NotificationService] Initial local notification: $decoded');
          handleNotificationData(decoded);
        }
      }
    } catch (e) {
      debugPrint('[NotificationService] checkInitialNotification error: $e');
    }
  }

  /// Handles navigating to the relevant screen based on the notification data payload.
  static Future<void> handleNotificationData(Map<String, dynamic> data) async {
    if (data.isEmpty) return;
    debugPrint('[NotificationService] Routing notification data: $data');

    // Wait until navigator is mounted (in case the app is launching from terminated state)
    for (int i = 0; i < 25; i++) {
      if (navigatorKey.currentState != null) break;
      await Future.delayed(const Duration(milliseconds: 200));
    }

    final nav = navigatorKey.currentState;
    if (nav == null) {
      debugPrint('[NotificationService] navigatorKey.currentState is null');
      return;
    }

    // Determine current user role
    String role = AppConstants.userRole;
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      try {
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        if (userDoc.exists) {
          role = userDoc.data()?['role']?.toString() ?? AppConstants.userRole;
        }
      } catch (e) {
        debugPrint('[NotificationService] Failed to read user role: $e');
      }
    }

    final type = data['type']?.toString().toLowerCase().trim() ?? '';

    switch (type) {
      case 'chat_message':
        if (role == AppConstants.adminRole) {
          final conversationId = data['conversationId']?.toString();
          if (conversationId != null && conversationId.isNotEmpty) {
            try {
              final doc = await FirebaseFirestore.instance
                  .collection('conversations')
                  .doc(conversationId)
                  .get();
              if (doc.exists && doc.data() != null) {
                final conversation =
                    ConversationModel.fromJson(doc.id, doc.data()!);
                nav.push(MaterialPageRoute(
                  builder: (_) =>
                      AdminChatDetailPage(conversation: conversation),
                ));
                return;
              }
            } catch (e) {
              debugPrint('[NotificationService] Failed to load conversation: $e');
            }
          }
          nav.push(MaterialPageRoute(
            builder: (_) => const AdminConversationsPage(),
          ));
        } else {
          nav.push(MaterialPageRoute(
            builder: (_) => const UserChatPage(),
          ));
        }
        break;

      case 'new_order':
        if (role == AppConstants.adminRole) {
          nav.push(MaterialPageRoute(
            builder: (_) => const OrdersScreen(adminMode: true),
          ));
        } else {
          nav.push(MaterialPageRoute(
            builder: (_) => const OrdersScreen(adminMode: false),
          ));
        }
        break;

      case 'order_status':
      case 'order_status_update':
        nav.push(MaterialPageRoute(
          builder: (_) => const OrdersScreen(adminMode: false),
        ));
        break;

      case 'new_product':
        final productId = data['productId']?.toString();
        if (productId != null && productId.isNotEmpty) {
          try {
            final doc = await FirebaseFirestore.instance
                .collection('products')
                .doc(productId)
                .get();
            if (doc.exists && doc.data() != null) {
              final product = ProductModel.fromJson(doc.id, doc.data()!);
              nav.push(MaterialPageRoute(
                builder: (_) => ProductDetailsPage(product: product),
              ));
              return;
            }
          } catch (e) {
            debugPrint('[NotificationService] Failed to load product: $e');
          }
        }
        nav.pushNamed(MainScreen.screenRoute);
        break;

      default:
        nav.push(MaterialPageRoute(
          builder: (_) => const NotificationsPage(),
        ));
        break;
    }
  }
}
