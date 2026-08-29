import 'package:ecommerceapp/core/widgets/custom_search_app_bar.dart';
import 'package:ecommerceapp/features/home/presentation/widgets/home_body.dart';
import 'package:flutter/material.dart';

/// HomePage widget representing the main screen of the application.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static const String screenRoute = 'home';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomSearchAppBar(),
      body: HomeBody(),
    );
  }
}