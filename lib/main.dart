import 'package:ecommerceapp/core/notifications/notification_service.dart';
import 'package:ecommerceapp/core/services/injection_container.dart';
import 'package:ecommerceapp/core/settings/app_settings.dart';
import 'package:ecommerceapp/core/theme/app_theme.dart';

import 'package:ecommerceapp/features/admin/screens/admin_home.dart';
import 'package:ecommerceapp/features/products/presentation/pages/add_product_page.dart';
import 'package:ecommerceapp/features/products/presentation/pages/mange_products_page.dart';

import 'package:ecommerceapp/features/authentication/presentation/pages/login_page.dart';
import 'package:ecommerceapp/features/authentication/presentation/pages/register_page.dart';
import 'package:ecommerceapp/features/authentication/presentation/manager/authentication_bloc.dart';

import 'package:ecommerceapp/features/favorites/presentation/pages/favorite_page.dart';

import 'package:ecommerceapp/features/carts/presentation/pages/cart_page.dart';

import 'package:ecommerceapp/features/profile/screens/profile_screen.dart';
import 'package:ecommerceapp/features/home/presentation/pages/home_page.dart';

import 'package:ecommerceapp/features/main/screens/main_screen.dart';

import 'package:ecommerceapp/features/orders/presentation/pages/order_screen.dart';

import 'package:ecommerceapp/features/settings/screens/setting_screen.dart';

import 'package:ecommerceapp/firebase_options.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await NotificationService.initialize();
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  final appSettings = AppSettings();
  await appSettings.loadSettings();

  // Initialize Dependency Injection
  InjectionContainer.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: appSettings),
        
        // Authentication BLoC
        BlocProvider(
          create: (_) => InjectionContainer.authenticationBloc
            ..add(const CheckAuthStatusEvent()),
        ),

        // Product Cubit
        BlocProvider(create: (_) => InjectionContainer.productCubit..loadProducts()),
        
        // Cart Cubit
        BlocProvider(
          create: (_) {
            final user = FirebaseAuth.instance.currentUser;
            final cubit = InjectionContainer.cartCubit;
            if (user != null) {
              cubit.loadCart(user.uid);
            }
            return cubit;
          },
        ),
        // Home Cubit
        BlocProvider(
          create: (_) {
            final user = FirebaseAuth.instance.currentUser;
            final cubit = InjectionContainer.homeCubit;
            if (user != null) {
              cubit.loadHomeData(user.uid);
            }
            return cubit;
          },
        ),
        // Favorite Cubit
        BlocProvider(
          create: (_) {
            final user = FirebaseAuth.instance.currentUser;
            final cubit = InjectionContainer.favoriteCubit;
            if (user != null) {
              cubit.loadFavorites(user.uid);
            }
            return cubit;
          },
        ),

        BlocProvider(create: (_) => InjectionContainer.orderCubit),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<AppSettings>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: ThemeData.dark(),
      themeMode: settings.themeMode,
      locale: settings.locale,
      supportedLocales: const [Locale('ar'), Locale('en')],
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      builder: (context, child) {
        return Directionality(
          textDirection: settings.locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
      initialRoute: FirebaseAuth.instance.currentUser != null
           ? MainScreen.screenRoute
           : RegisterPage.screenRoute,
       routes: {
         RegisterPage.screenRoute: (_) => const RegisterPage(),
         LoginPage.screenRoute: (_) => const LoginPage(),
        HomePage.screenRoute: (_) => const HomePage(),


        AdminHome.screenRoute: (_) => const AdminHome(),
        ManageProductsPage.screenRoute: (_) => const ManageProductsPage(),
        AddProductPage.screenRoute: (_) => const AddProductPage(),
        CartPage.screenRoute: (_) => const CartPage(),
        FavoritePage.screenRoute: (_) => const FavoritePage(),

        MainScreen.screenRoute: (_) => const MainScreen(),
        OrdersScreen.screenRoute: (_) => const OrdersScreen(),
        SettingsScreen.screenRoute: (_) => const SettingsScreen(),
        ProfileScreen.screenRoute: (_) => const ProfileScreen(),
      },
    );
  }
}
