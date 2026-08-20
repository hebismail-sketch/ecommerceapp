import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/cart_entity.dart';
import '../manager/cart_cubit.dart';
import '../../../products/presentation/manager/product_cubit.dart';
import '../../../../l10n/app_localizations.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  static const String screenRoute = 'cart';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cart),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartFailure) {
            return Center(child: Text(state.message));
          }

          if (state is CartSuccess) {
            if (state.cartItems.isEmpty) {
              return Center(child: Text(l10n.emptyCart, style: const TextStyle(fontSize: 20)));
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cartItems.length,
                    itemBuilder: (context, index) {
                      final cartItem = state.cartItems[index];
                      // Fetch product details using ProductCubit
                      final product = context.read<ProductCubit>().getProductById(cartItem.productId);

                      if (product == null) return const SizedBox();

                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            children: [
                              Image.network(product.image, width: 80, height: 80, fit: BoxFit.cover),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(locale.languageCode == 'ar' ? product.nameAr : product.nameEn,
                                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    Text("${product.price} USD"),
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () => context.read<CartCubit>().decreaseQuantity(cartItem),
                                          icon: const Icon(Icons.remove_circle_outline),
                                        ),
                                        Text('${cartItem.quantity}', style: const TextStyle(fontSize: 16)),
                                        IconButton(
                                          onPressed: () => context.read<CartCubit>().increaseQuantity(cartItem),
                                          icon: const Icon(Icons.add_circle_outline),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () => context.read<CartCubit>().removeItem(cartItem.id),
                                icon: const Icon(Icons.delete, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Total Price Section
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(l10n.totalPrices, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("${context.read<CartCubit>().totalPrice} USD",
                          style: const TextStyle(fontSize: 20, color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}