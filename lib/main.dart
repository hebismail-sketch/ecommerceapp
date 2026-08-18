import 'package:ecommerceapp/core/notifications/notification_service.dart';
import 'package:ecommerceapp/core/settings/app_settings.dart';
import 'package:ecommerceapp/core/theme/app_theme.dart';

import 'package:ecommerceapp/features/admin/screens/add_cars_screen.dart';
import 'package:ecommerceapp/features/admin/screens/admin_home.dart';
import 'package:ecommerceapp/features/admin/screens/manage_cars_screen.dart';

import 'package:ecommerceapp/features/authentication/screens/login_screen.dart';
import 'package:ecommerceapp/features/authentication/screens/register_screen.dart';

import 'package:ecommerceapp/features/cars/controller/car_cubit.dart';

import 'package:ecommerceapp/features/carts/controller/cart_cubit.dart';
import 'package:ecommerceapp/features/carts/screens/checkout_screen.dart';

import 'package:ecommerceapp/features/favorites/controller/favorite_cubit.dart';
import 'package:ecommerceapp/features/favorites/screens/favorite_screen.dart';
import 'package:ecommerceapp/features/profile/screens/profile_screen.dart';
import 'package:ecommerceapp/features/home/screens/home_screen.dart';

import 'package:ecommerceapp/features/main/screens/main_screen.dart';

import 'package:ecommerceapp/features/orders/controller/order_cubit.dart';
import 'package:ecommerceapp/features/orders/screens/order_screen.dart';

import 'package:ecommerceapp/features/settings/screens/setting_screen.dart';

import 'package:ecommerceapp/firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
// ======================================================
// Firebase Background Notification Handler
// ======================================================

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  debugPrint('Background notification: ${message.notification?.title}');
}

// ======================================================
// Main
// ======================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ====================================================
  // 1. Initialize Firebase
  // ====================================================

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // ====================================================
  // 2. Initialize Local Notifications
  // ====================================================

  await NotificationService.initialize();

  // ====================================================
  // 3. Register Firebase Background Message Handler
  // ====================================================

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // ====================================================
  // 4. Firebase Messaging Instance
  // ====================================================

  final messaging = FirebaseMessaging.instance;

  // ====================================================
  // 5. Request Notification Permission
  // ====================================================

  final notificationSettings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  debugPrint(
    'Notification permission: '
    '${notificationSettings.authorizationStatus}',
  );

  // ====================================================
  // 6. Get FCM Token
  // ====================================================

  final token = await messaging.getToken();

  debugPrint('FCM TOKEN: $token');

  // ====================================================
  // 7. Foreground Notifications
  // ====================================================

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint(
      'Foreground notification: '
      '${message.notification?.title}',
    );

    debugPrint('Body: ${message.notification?.body}');

    final notification = message.notification;

    if (notification != null) {
      NotificationService.showNotification(
        title: notification.title ?? 'إشعار جديد',
        body: notification.body ?? '',
      );
    }
  });

  // ====================================================
  // 8. Load App Settings
  // ====================================================

  final appSettings = AppSettings();

  await appSettings.loadSettings();

  // ====================================================
  // 9. Run Application
  // ====================================================

  runApp(
    MultiProvider(
      providers: [
        // App Settings
        ChangeNotifierProvider.value(value: appSettings),

        // Cars
        BlocProvider(create: (_) => CarCubit()),

        // Cart
        BlocProvider(create: (_) => CartCubit()),

        // Favorites
        BlocProvider(create: (_) => FavoriteCubit()),

        // Orders
        BlocProvider(create: (_) => OrderCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

// ======================================================
// My App
// ======================================================

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ==================================================
      // Theme
      // ==================================================
      theme: AppTheme.lightTheme,

      darkTheme: ThemeData.dark(),

      themeMode: settings.themeMode,

      // ==================================================
      // Language
      // ==================================================
      locale: settings.locale,

      supportedLocales: const [Locale('ar'), Locale('en')],

      // ==================================================
      // Localization Delegates
      // ==================================================
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      // ==================================================
      // RTL / LTR
      // ==================================================
      builder: (context, child) {
        return Directionality(
          textDirection: settings.locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },

      // ==================================================
      // Initial Route
      // ==================================================
      initialRoute: FirebaseAuth.instance.currentUser != null
          ? MainScreen.screenRoute
          : RegisterScreen.screenRoute,

      // ==================================================
      // Routes
      // ==================================================
      routes: {
        // Authentication
        RegisterScreen.screenRoute: (_) => const RegisterScreen(),

        LoginScreen.screenRoute: (_) => const LoginScreen(),

        // Home
        HomeScreen.screenRoute: (_) => const HomeScreen(),

        // Checkout
        CheckOut.screenRoute: (_) => const CheckOut(),

        // Admin
        AdminHome.screenRoute: (_) => const AdminHome(),

        AddCarScreen.screenRoute: (_) => const AddCarScreen(),

        ManageCarsScreen.screenRoute: (_) => const ManageCarsScreen(),

        // Favorites
        FavoriteScreen.screenRoute: (_) => const FavoriteScreen(),

        // Main
        MainScreen.screenRoute: (_) => const MainScreen(),

        // Orders
        OrdersScreen.screenRoute: (_) => const OrdersScreen(),

        // Settings
        SettingsScreen.screenRoute: (_) => const SettingsScreen(),
// Profile
        ProfileScreen.screenRoute: (_) => const ProfileScreen(),
      },
    );
  }
}
