import 'package:flutter/material.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';

class ProductCategory {
  final String id;
  final IconData icon;
  final String Function(AppLocalizations) getTitle;

  const ProductCategory({
    required this.id,
    required this.icon,
    required this.getTitle,
  });
}

class ProductCategoryHelper {
  static const String all = 'all';
  static const String clothing = 'clothing';
  static const String cars = 'cars';
  static const String beauty = 'beauty';
  static const String watches = 'watches';
  static const String bags = 'bags';
  static const String accessories = 'accessories';
  static const String games = 'games';
  static const String furniture = 'furniture';
  static const String shoes = 'shoes';
  static const String medicine = 'medicine';

  /// All categories including 'All' for the user home filter
  static List<ProductCategory> getCategories() {
    return [
      ProductCategory(
        id: all,
        icon: Icons.grid_view_rounded,
        getTitle: (l10n) => l10n.allCategories,
      ),
      ProductCategory(
        id: clothing,
        icon: Icons.checkroom,
        getTitle: (l10n) => l10n.clothing,
      ),
      ProductCategory(
        id: cars,
        icon: Icons.directions_car,
        getTitle: (l10n) => l10n.cars,
      ),
      ProductCategory(
        id: beauty,
        icon: Icons.auto_awesome,
        getTitle: (l10n) => l10n.beauty,
      ),
      ProductCategory(
        id: watches,
        icon: Icons.watch,
        getTitle: (l10n) => l10n.watches,
      ),
      ProductCategory(
        id: bags,
        icon: Icons.shopping_bag_outlined,
        getTitle: (l10n) => l10n.bags,
      ),
      ProductCategory(
        id: accessories,
        icon: Icons.diamond_outlined,
        getTitle: (l10n) => l10n.accessories,
      ),
      ProductCategory(
        id: games,
        icon: Icons.sports_esports_outlined,
        getTitle: (l10n) => l10n.games,
      ),
      ProductCategory(
        id: furniture,
        icon: Icons.chair_outlined,
        getTitle: (l10n) => l10n.furniture,
      ),
      ProductCategory(
        id: shoes,
        icon: Icons.shopping_cart_outlined,
        getTitle: (l10n) => l10n.shoes,
      ),
      ProductCategory(
        id: medicine,
        icon: Icons.medical_services_outlined,
        getTitle: (l10n) => l10n.medicine,
      ),
    ];
  }

  /// Categories available for selection when adding or editing a product (excludes 'all')
  static List<ProductCategory> getSelectableCategories() {
    return getCategories().where((c) => c.id != all).toList();
  }

  /// Get localized title for a category by its ID
  static String getCategoryName(String categoryId, AppLocalizations l10n) {
    if (categoryId.isEmpty || categoryId == all) {
      return l10n.allCategories;
    }
    final match = getCategories().where((c) => c.id == categoryId);
    if (match.isNotEmpty) {
      return match.first.getTitle(l10n);
    }
    return categoryId;
  }

  /// Get icon for a category by its ID
  static IconData getCategoryIcon(String categoryId) {
    final match = getCategories().where((c) => c.id == categoryId);
    if (match.isNotEmpty) {
      return match.first.icon;
    }
    return Icons.category_outlined;
  }
}
