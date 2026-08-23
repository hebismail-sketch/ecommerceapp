import 'package:flutter/material.dart';

import 'package:ecommerceapp/features/home/presentation/pages/home_page.dart';
import 'package:ecommerceapp/features/favorites/presentation/pages/favorite_page.dart';
import 'package:ecommerceapp/features/orders/presentation/pages/order_screen.dart';
import 'package:ecommerceapp/features/carts/presentation/pages/cart_page.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String screenRoute = 'main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    HomePage(),
    FavoritePage(),
    OrdersScreen(),
    CartPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      body: _screens[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,

        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },

        type: BottomNavigationBarType.fixed,

        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_outlined),
            activeIcon: const Icon(Icons.home),
            label: l10n.home,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite_border),
            activeIcon: const Icon(Icons.favorite),
            label: l10n.favorites,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long_outlined),
            activeIcon: const Icon(Icons.receipt_long),
            label: l10n.orders,
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.shopping_cart_outlined),
            activeIcon: const Icon(Icons.shopping_cart),
            label: l10n.cart,
          ),
        ],
      ),
    );
  }
}