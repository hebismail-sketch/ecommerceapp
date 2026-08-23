import 'package:ecommerceapp/core/widgets/profile_avatar.dart';
import 'package:ecommerceapp/features/home/presentation/widgets/home_body.dart';
import 'package:ecommerceapp/features/profile/screens/profile_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String screenRoute = 'home';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ProfileAvatar(
          imageUrl: null,
          onTap: () {
            Navigator.pushNamed(
              context,
              ProfileScreen.screenRoute,
            );
          },
        ),
        title: Text(
          AppLocalizations.of(context)!.carStore,
        ),
        centerTitle: true,
      ),
      body: const HomeBody(),
    );
  }
}