import 'package:ecommerceapp/core/widgets/profile_avatar.dart';
import 'package:ecommerceapp/features/carts/screens/checkout_screen.dart';
import 'package:ecommerceapp/features/favorites/screens/favorite_screen.dart';
import 'package:ecommerceapp/features/home/widgets/home_body.dart';
import 'package:ecommerceapp/features/orders/screens/order_screen.dart';
import 'package:ecommerceapp/features/profile/screens/profile_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  static const String screenRoute = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int currentIndex = 0;

  final List<Widget> screens = const [
    HomeBody(),
    FavoriteScreen(),
    OrdersScreen(),
    CheckOut(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(leading: ProfileAvatar(
        imageUrl: null,
        onTap: () async{await
          Navigator.pushNamed(
            context,
            ProfileScreen.screenRoute,
          );if(mounted){setState(() {

          });}
        },
      ),
        title:  Text(AppLocalizations.of(context)!.carStore),
        centerTitle: true,
      ),
      body: screens[currentIndex],

    );
  }
}