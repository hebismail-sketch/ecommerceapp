// File: lib/core/widgets/custom_search_app_bar.dart

import 'package:ecommerceapp/core/widgets/profile_avatar.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/features/profile/presentation/pages/profile_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Reusable Custom AppBar matching HomePage styling across all primary screens.
class CustomSearchAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final TextEditingController? searchController;
  final ValueChanged<String>? onSearchChanged;

  const CustomSearchAppBar({
    super.key,
    this.showBackButton = false,
    this.searchController,
    this.onSearchChanged,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final canPop = Navigator.canPop(context);

    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: showBackButton && canPop
          ? IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            )
          : Padding(
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
          controller: searchController,
          onChanged: onSearchChanged ??
              (value) {
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
      actions: showBackButton && canPop
          ? [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: ProfileAvatar(
                  size: 32,
                  imageUrl: null,
                  onTap: () {
                    Navigator.pushNamed(context, ProfileScreen.screenRoute);
                  },
                ),
              ),
            ]
          : null,
    );
  }
}
