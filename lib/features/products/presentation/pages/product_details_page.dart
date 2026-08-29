// File: lib/features/products/presentation/pages/product_details_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerceapp/features/carts/domain/entities/cart_entity.dart';
import 'package:ecommerceapp/features/carts/presentation/manager/cart_cubit.dart';
import 'package:ecommerceapp/features/favorites/presentation/manager/favorite_cubit.dart';
import 'package:ecommerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';

class ProductDetailsPage extends StatelessWidget {
  final ProductEntity product;

  const ProductDetailsPage({
    super.key,
    required this.product,
  });

  static const String screenRoute = 'productDetails';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final name = isArabic ? product.nameAr : product.nameEn;
    final brand = isArabic ? product.brandAr : product.brandEn;
    final location = isArabic ? product.locationAr : product.locationEn;
    final description = isArabic ? product.descriptionAr : product.descriptionEn;

    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image with Favorite Button
            Stack(
              children: [
                Image.network(
                  product.image,
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const SizedBox(height: 250, child: Icon(Icons.image_not_supported, size: 60)),
                ),
                Positioned(
                  top: 16,
                  right: isArabic ? null : 16,
                  left: isArabic ? 16 : null,
                  child: BlocBuilder<FavoriteCubit, FavoriteState>(
                    builder: (context, state) {
                      final isFav = context.read<FavoriteCubit>().isFavorite(product.id);
                      return CircleAvatar(
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.red : Colors.grey.shade700,
                          ),
                          onPressed: () {
                            final user = FirebaseAuth.instance.currentUser;
                            if (user != null) {
                              context.read<FavoriteCubit>().toggleFavorite(user.uid, product.id);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(l10n.pleaseLoginFirst)),
                              );
                            }
                          },
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),

            // Car Information
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Text(
                        '${product.price}${l10n.egp}',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Brand & Year & Location Chips
                  Wrap(
                    spacing: 8,
                    children: [
                      Chip(
                        avatar: const Icon(Icons.branding_watermark, size: 16),
                        label: Text(brand),
                      ),
                      Chip(
                        avatar: const Icon(Icons.calendar_today, size: 16),
                        label: Text('${product.year}'),
                      ),
                      Chip(
                        avatar: const Icon(Icons.location_on, size: 16),
                        label: Text(location),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Description
                  Text(
                    l10n.description,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    description.isNotEmpty ? description : '---',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Add to Cart Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade600,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: Text(
              l10n.cart,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                context.read<CartCubit>().addToCart(
                      user.uid,
                      CartEntity(
                        id: '',
                        productId: product.id,
                        quantity: 1,
                        price: product.price,
                      ),
                    );
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.orderConfirmedSuccessfully)),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.pleaseLoginFirst)),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
