import 'package:ecommerceapp/core/widgets/profile_avatar.dart';
import 'package:ecommerceapp/features/chat/presentation/pages/user_chat_page.dart';
import 'package:ecommerceapp/features/home/presentation/widgets/home_body.dart';
import 'package:ecommerceapp/features/profile/presentation/pages/profile_screen.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// HomePage widget representing the main screen of the application.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String screenRoute = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Track the current active index of the bottom navigation bar
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      // Top app bar with search field and profile avatar
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ProfileAvatar(
            imageUrl: null,
            onTap: () {
              Navigator.pushNamed(context, ProfileScreen.screenRoute);
            },
          ),
        ),
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: TextField(
            onChanged: (value) {
              context.read<ProductCubit>().searchProducts(value);
            },
            decoration: InputDecoration(
              hintText: l10n.searchForCar,
              hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, size: 20, color: Colors.grey),

              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
            ),
          ),
        ),
      ),

      // Home body content
      body: const HomeBody(),


    );
  }
}