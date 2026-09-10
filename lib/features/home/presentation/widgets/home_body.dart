// File: lib/features/home/presentation/widgets/home_body.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerceapp/features/products/presentation/pages/product_details_page.dart';

import 'package:ecommerceapp/core/constants/app_categories.dart';
import 'package:ecommerceapp/core/theme/app_colors.dart';
import 'package:ecommerceapp/features/favorites/presentation/manager/favorite_cubit.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';

/// HomeBody widget containing the promotional banner, sticky categories, and product grid with full dual-language support.
class HomeBody extends StatefulWidget {
  const HomeBody({super.key});

  @override
  State<HomeBody> createState() => _HomeBodyState();
}

class _HomeBodyState extends State<HomeBody> {
  String _selectedCategoryId = ProductCategoryHelper.all;

  @override
  void initState() {
    super.initState();
    // Load user favorites on screen initialization
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<FavoriteCubit>().loadFavorites(user.uid);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final categories = ProductCategoryHelper.getCategories();

    return NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          // Promotional Banner section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                height: 140,
                decoration: BoxDecoration(
                  gradient: isDark
                      ? AppColors.darkBannerGradient
                      : LinearGradient(
                          colors: [Colors.red.shade400, Colors.red.shade700],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.circular(16),
                  border: isDark
                      ? Border.all(color: AppColors.darkBorderGold, width: 1.2)
                      : null,
                  boxShadow: isDark
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.35),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ]
                      : null,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppColors.gold.withOpacity(0.18)
                              : Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(6),
                          border: isDark
                              ? Border.all(
                                  color: AppColors.gold.withOpacity(0.4),
                                  width: 0.8,
                                )
                              : null,
                        ),
                        child: Text(
                          l10n.bestSeller,
                          style: TextStyle(
                            color: isDark ? AppColors.gold : Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.bannerHeadline,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        height: 28,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: isDark ? AppColors.gold : Colors.white,
                            foregroundColor:
                                isDark ? const Color(0xFF0B0E14) : Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: isDark ? 3 : 0,
                            shadowColor:
                                isDark ? AppColors.goldGlow : Colors.transparent,
                          ),
                          onPressed: () {},
                          child: Text(
                            l10n.shopNow,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Sticky Categories header that remains pinned when scrolling
          SliverPersistentHeader(
            pinned: true,
            delegate: _SliverCategoryDelegate(
              child: Container(
                color: isDark ? AppColors.darkBackground : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            l10n.categories,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: isDark ? Colors.white : Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      height: 72,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        itemCount: categories.length,
                        itemBuilder: (context, index) {
                          final cat = categories[index];
                          final isSelected = _selectedCategoryId == cat.id;

                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 6),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  if (_selectedCategoryId == cat.id &&
                                      cat.id != ProductCategoryHelper.all) {
                                    _selectedCategoryId =
                                        ProductCategoryHelper.all;
                                  } else {
                                    _selectedCategoryId = cat.id;
                                  }
                                });
                              },
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.gold
                                          : (isDark
                                              ? AppColors.darkCard
                                              : Colors.grey.shade100),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.gold
                                            : (isDark
                                                ? AppColors.darkBorder
                                                : Colors.grey.shade300),
                                        width: isSelected ? 1.5 : 1.0,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: AppColors.goldGlow,
                                                blurRadius: 8,
                                                offset: const Offset(0, 2),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Icon(
                                      cat.icon,
                                      size: 20,
                                      color: isSelected
                                          ? const Color(0xFF0B0E14)
                                          : (isDark
                                              ? AppColors.gold
                                              : Colors.black87),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    cat.getTitle(l10n),
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: isSelected
                                          ? (isDark
                                              ? AppColors.goldLight
                                              : Colors.red.shade700)
                                          : (isDark
                                              ? AppColors.darkTextSecondary
                                              : Colors.black87),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ];
      },

      // Recommended Products Section
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _selectedCategoryId == ProductCategoryHelper.all
                      ? l10n.recommended
                      : ProductCategoryHelper.getCategoryName(
                          _selectedCategoryId,
                          l10n,
                        ),
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : Colors.black87,
                  ),
                ),
                if (_selectedCategoryId != ProductCategoryHelper.all)
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    onPressed: () {
                      setState(() =>
                          _selectedCategoryId = ProductCategoryHelper.all);
                    },
                    child: Text(
                      l10n.allCategories,
                      style: TextStyle(
                        color: isDark ? AppColors.gold : Colors.red.shade700,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: BlocBuilder<ProductCubit, ProductState>(
                builder: (context, state) {
                  if (state is ProductLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is ProductFailure) {
                    return Center(child: Text(state.message));
                  }

                  if (state is ProductSuccess) {
                    final filteredProducts = _selectedCategoryId ==
                            ProductCategoryHelper.all
                        ? state.products
                        : state.products
                            .where((p) => p.category == _selectedCategoryId)
                            .toList();

                    if (filteredProducts.isEmpty) {
                      final catName = ProductCategoryHelper.getCategoryName(
                        _selectedCategoryId,
                        l10n,
                      );
                      final catIcon = ProductCategoryHelper.getCategoryIcon(
                        _selectedCategoryId,
                      );

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24.0,
                            vertical: 32.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.red.shade50,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  catIcon,
                                  size: 48,
                                  color: Colors.red.shade600,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                l10n.noProductsInCategory(catName),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                ),
                                onPressed: () {
                                  setState(() => _selectedCategoryId =
                                      ProductCategoryHelper.all);
                                },
                                icon: const Icon(
                                  Icons.grid_view_rounded,
                                  size: 18,
                                ),
                                label: Text(l10n.allCategories),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    // Product Grid View layout matching modern e-commerce cards
                    return GridView.builder(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.72,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                      ),
                      itemCount: filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = filteredProducts[index];
                        final productName = isArabic ? product.nameAr : product.nameEn;

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProductDetailsPage(product: product),
                              ),
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.darkCard : Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color: isDark
                                    ? AppColors.darkBorder
                                    : Colors.grey.shade200,
                              ),
                              boxShadow: isDark
                                  ? [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.35),
                                        blurRadius: 8,
                                        offset: const Offset(0, 3),
                                      ),
                                    ]
                                  : [
                                      BoxShadow(
                                        color: Colors.grey.shade100,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Image.network(
                                        product.image,
                                        height: 100,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) =>
                                            const SizedBox(height: 100, child: Icon(Icons.image_not_supported)),
                                      ),
                                    ),
                                    // Real-time favorite heart toggle button
                                    BlocBuilder<FavoriteCubit, FavoriteState>(
                                      builder: (context, favState) {
                                        final isFav = context.read<FavoriteCubit>().isFavorite(product.id);

                                        return Positioned(
                                          top: 8,
                                          right: isArabic ? null : 8,
                                          left: isArabic ? 8 : null,
                                          child: GestureDetector(
                                            onTap: () {
                                              final user = FirebaseAuth.instance.currentUser;
                                              if (user != null) {
                                                // Toggle product in user's favorites
                                                context.read<FavoriteCubit>().toggleFavorite(
                                                      user.uid,
                                                      product.id,
                                                    );
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  SnackBar(
                                                    content: Text(l10n.pleaseLoginFirst),
                                                  ),
                                                );
                                              }
                                            },
                                            child: Container(
                                              padding: const EdgeInsets.all(5),
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? AppColors.darkSurface
                                                    : Colors.white,
                                                shape: BoxShape.circle,
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.18),
                                                    blurRadius: 4,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Icon(
                                                isFav
                                                    ? Icons.favorite
                                                    : Icons.favorite_border,
                                                size: 18,
                                                color: isFav
                                                    ? Colors.red
                                                    : (isDark
                                                        ? AppColors.gold
                                                        : Colors.grey.shade600),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        productName,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                          color: isDark
                                              ? Colors.white
                                              : Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${product.price}${l10n.egp}',
                                        style: TextStyle(
                                          color: isDark
                                              ? AppColors.gold
                                              : Colors.red,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.star,
                                            size: 12,
                                            color: AppColors.gold,
                                          ),
                                          const SizedBox(width: 4),
                                          Text(
                                            '4.9',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: isDark
                                                  ? AppColors.darkTextMuted
                                                  : Colors.grey,
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '| ${l10n.sold('56')}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              color: isDark
                                                  ? AppColors.darkTextMuted
                                                  : Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }

                  return const SizedBox();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Custom SliverPersistentHeaderDelegate to handle sticky categories header safely
class _SliverCategoryDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;
  _SliverCategoryDelegate({required this.child});

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  double get maxExtent => 135;
  @override
  double get minExtent => 135;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => true;
}
