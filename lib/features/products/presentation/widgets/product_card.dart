import 'package:ecommerceapp/features/products/domain/entities/product_entity.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  final ProductEntity product;
  final VoidCallback? onTap;

  const ProductCard({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final productName = isArabic ? product.nameAr : product.nameEn;
    final productBrand = isArabic ? product.brandAr : product.brandEn;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                product.image,
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                const SizedBox(height: 150, child: Icon(Icons.image_not_supported, size: 50)),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Name
                  Text(
                    productName,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  // Product Brand & Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(productBrand, style: TextStyle(color: Colors.grey[600])),
                      Text(
                        "${product.price} ${l10n.egp}",
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.green),
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
  }
}