// File: lib/features/carts/presentation/pages/cart_page.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:ecommerceapp/core/widgets/custom_search_app_bar.dart';
import 'package:ecommerceapp/features/carts/presentation/manager/cart_cubit.dart';
import 'package:ecommerceapp/features/orders/domain/entities/order_entity.dart';
import 'package:ecommerceapp/features/orders/presentation/manager/order_cubit.dart';
import 'package:ecommerceapp/features/orders/presentation/pages/delivery_details_page.dart';
import 'package:ecommerceapp/features/orders/presentation/pages/delivery_location_page.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/features/products/presentation/pages/product_details_page.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:latlong2/latlong.dart';

/// Modern eCommerce CartPage with premium card design and seamless checkout
class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const String screenRoute = 'cart';

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  bool _isSubmittingOrder = false;
  String _selectedPaymentMethod = 'cashOnDelivery';

  Future<void> _submitCashOnDeliveryOrder({
    required BuildContext context,
    required CartSuccess cartState,
    required double totalPrice,
    required AppLocalizations l10n,
  }) async {
    if (_isSubmittingOrder) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.pleaseLoginFirst)));
      return;
    }

    setState(() => _isSubmittingOrder = true);
    try {
      final selectedLocation = await Navigator.push<LatLng>(
        context,
        MaterialPageRoute(
          builder: (_) => const DeliveryLocationPage(),
        ),
      );

      if (!mounted || selectedLocation == null) return;

      final deliveryDetails = await Navigator.push<DeliveryDetails>(
        context,
        MaterialPageRoute(
          builder: (_) => DeliveryDetailsPage(
            selectedLocation: selectedLocation,
          ),
        ),
      );

      if (!mounted || deliveryDetails == null) return;

      final orderCubit = context.read<OrderCubit>();
      final cartCubit = context.read<CartCubit>();
      final cartItems = cartState.cartItems;
      final carIds = cartItems.map((item) => item.productId).toList();
      final order = OrderEntity(
        id: '',
        userId: user.uid,
        carIds: carIds,
        totalPrice: totalPrice,
        orderDate: DateTime.now(),
        paymentMethod: _selectedPaymentMethod,
        paymentStatus: 'pending',
        firstName: deliveryDetails.firstName,
        lastName: deliveryDetails.lastName,
        phone: deliveryDetails.phone,
        street: deliveryDetails.street,
        buildingNumber: deliveryDetails.buildingNumber,
        floorNumber: deliveryDetails.floorNumber,
        apartmentNumber: deliveryDetails.apartmentNumber,
        additionalNotes: deliveryDetails.additionalNotes,
        latitude: deliveryDetails.latitude,
        longitude: deliveryDetails.longitude,
      );

      await orderCubit.addOrder(order);
      for (final item in cartItems) {
        await cartCubit.removeItem(item.id);
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green.shade600,
            content: Text(
              '${l10n.orderConfirmedSuccessfully} - ${l10n.cashOnDelivery}',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text(l10n.orderCreationFailed),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmittingOrder = false);
    }
  }

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        context.read<CartCubit>().loadCart(user.uid);
      });
    }
  }

  Widget _buildEmptyCart(AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(28),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_bag_outlined,
                size: 72,
                color: Colors.red.shade400,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              l10n.emptyCart,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              l10n.emptyCartMessage,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const CustomSearchAppBar(showBackButton: true),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is CartFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          if (state is CartSuccess) {
            if (state.cartItems.isEmpty) {
              return _buildEmptyCart(l10n);
            }

            final totalPrice = context.read<CartCubit>().totalPrice;

            return Column(
              children: [
                // Cart items list with modern card styling
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.cartItems.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final cartItem = state.cartItems[index];
                      final product = context
                          .read<ProductCubit>()
                          .getProductById(cartItem.productId);

                      if (product == null) return const SizedBox.shrink();

                      final productName = isArabic
                          ? product.nameAr
                          : product.nameEn;

                      return Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Product Image with click to details
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          ProductDetailsPage(product: product),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    product.image,
                                    width: 85,
                                    height: 85,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stack) =>
                                        Container(
                                          width: 85,
                                          height: 85,
                                          color: Colors.grey.shade100,
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            color: Colors.grey,
                                          ),
                                        ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Title, Price and Quantity Controls
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      productName,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Text(
                                      '${product.price}${l10n.egp}',
                                      style: TextStyle(
                                        color: Colors.red.shade600,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        // Quantity counter with rounded buttons
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 4,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                onTap: () => context
                                                    .read<CartCubit>()
                                                    .decreaseQuantity(cartItem),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    4.0,
                                                  ),
                                                  child: Icon(
                                                    Icons.remove,
                                                    size: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                    ),
                                                child: Text(
                                                  '${cartItem.quantity}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                                onTap: () => context
                                                    .read<CartCubit>()
                                                    .increaseQuantity(cartItem),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                    4.0,
                                                  ),
                                                  child: Icon(
                                                    Icons.add,
                                                    size: 16,
                                                    color: Colors.grey.shade800,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Delete Button
                                        IconButton(
                                          onPressed: () => context
                                              .read<CartCubit>()
                                              .removeItem(cartItem.id),
                                          icon: Icon(
                                            Icons.delete_outline,
                                            color: Colors.red.shade400,
                                            size: 22,
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
                  ),
                ),

                // Order Summary & Checkout Bottom Bar
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              l10n.totalPrices,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              '${totalPrice.toStringAsFixed(0)}${l10n.egp}',
                              style: const TextStyle(
                                fontSize: 22,
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: Colors.red.shade100),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.payments_outlined,
                                color: Colors.red.shade700,
                                size: 28,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.paymentMethod,
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      l10n.cashOnDelivery,
                                      style: TextStyle(
                                        color: Colors.grey.shade700,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Radio<String>(
                                value: 'cashOnDelivery',
                                groupValue: _selectedPaymentMethod,
                                activeColor: Colors.red.shade700,
                                onChanged: _isSubmittingOrder
                                    ? null
                                    : (value) {
                                        if (value == null) return;
                                        setState(
                                          () => _selectedPaymentMethod = value,
                                        );
                                      },
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          height: 52,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red.shade600,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14),
                              ),
                            ),
                            onPressed: _isSubmittingOrder
                                ? null
                                : () => _submitCashOnDeliveryOrder(
                                    context: context,
                                    cartState: state,
                                    totalPrice: totalPrice,
                                    l10n: l10n,
                                  ),
                            child: _isSubmittingOrder
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                      color: Colors.white,
                                    ),
                                  )
                                : Text(
                                    l10n.confirmOrder,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
