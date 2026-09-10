// File: lib/core/widgets/custom_search_app_bar.dart

import 'package:ecommerceapp/core/theme/app_colors.dart';
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      elevation: 0,
      backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
      leading: showBackButton && canPop
          ? IconButton(
              icon: Icon(
                Icons.arrow_back_ios_new,
                color: isDark ? AppColors.gold : Colors.black87,
                size: 20,
              ),
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
          color: isDark ? AppColors.darkSurface : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? AppColors.darkBorder : Colors.grey.shade300,
          ),
        ),
        child: TextField(
          controller: searchController,
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black87,
            fontSize: 14,
          ),
          onChanged: onSearchChanged ??
              (value) {
                context.read<ProductCubit>().searchProducts(value);
              },
          decoration: InputDecoration(
            hintText: l10n.searchForCar,
            hintStyle: TextStyle(
              fontSize: 14,
              color: isDark ? AppColors.darkTextMuted : Colors.grey.shade500,
            ),
            prefixIcon: Icon(
              Icons.search,
              size: 20,
              color: isDark ? AppColors.gold : Colors.grey,
            ),
            suffixIcon: Icon(
              Icons.tune_rounded,
              size: 18,
              color: isDark ? AppColors.gold : Colors.grey.shade400,
            ),
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
