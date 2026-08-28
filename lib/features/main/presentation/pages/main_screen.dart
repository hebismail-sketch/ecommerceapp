import 'package:flutter/material.dart';

import 'package:ecommerceapp/features/home/presentation/pages/home_page.dart';
import 'package:ecommerceapp/features/favorites/presentation/pages/favorite_page.dart';
import 'package:ecommerceapp/features/orders/presentation/pages/order_screen.dart';
import 'package:ecommerceapp/features/carts/presentation/pages/cart_page.dart';
import 'package:ecommerceapp/features/chat/presentation/pages/user_chat_page.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';

/// MainScreen widget managing the bottom navigation bar and switching between primary app screens.
class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  static const String screenRoute = 'main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  // Track the active index of the bottom navigation bar
  int _currentIndex = 0;

  // List of primary screens corresponding to bottom bar items
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
      // Display the current selected screen body
      body: _screens[_currentIndex > 2 ? _currentIndex - 1 : _currentIndex],

      // Unified Bottom Navigation Bar with exact colors and centered chat button
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red.shade400,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 2) {
            // Navigate directly to the chat page when the center chat button is tapped
            Navigator.pushNamed(context, UserChatPage.screenRoute);
          } else {
            setState(() {
              // Adjust index if tapped items are after the chat button
              _currentIndex = index;
            });
          }
        },
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
          // Custom centered circular floating chat icon button matching HomePage style
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade400,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.shade200,
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 36),
            ),
            label: l10n.chat,
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