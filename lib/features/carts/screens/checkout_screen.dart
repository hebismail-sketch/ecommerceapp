import 'package:ecommerceapp/features/cars/controller/car_cubit.dart';
import 'package:ecommerceapp/features/carts/controller/cart_cubit.dart';
import 'package:ecommerceapp/features/carts/models/cart_model.dart';
import 'package:ecommerceapp/features/orders/controller/order_cubit.dart';
import 'package:ecommerceapp/features/orders/models/order_model.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:ecommerceapp/core/notifications/notification_service.dart';

class CheckOut extends StatefulWidget {
  const CheckOut({super.key});

  static const String screenRoute = 'checkout';

  @override
  State<CheckOut> createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      context.read<CartCubit>().loadCart(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.cart),
        centerTitle: true,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state is CartLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CartFailure) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is CartSuccess) {
            if (state.cartItems.isEmpty) {
              return Center(
                child: Text(
                  l10n.emptyCart,
                  style: const TextStyle(
                    fontSize: 20,
                  ),
                ),
              );
            }

            return _buildCartContent(
              context,
              state.cartItems,
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildCartContent(
      BuildContext context,
      List<CartModel> cartItems,
      ) {
    final locale = Localizations.localeOf(context);
    final carCubit = context.read<CarCubit>();
    final cartCubit = context.read<CartCubit>();
    final l10n = AppLocalizations.of(context)!;

    final totalPrice = cartCubit.totalPrice;

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: cartItems.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final cartItem = cartItems[index];

              final car = carCubit.cars.firstWhere(
                    (car) => car.id == cartItem.carId,
              );

              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          car.image,
                          width: 90,
                          height: 90,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              car.nameFor(locale),
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              '${NumberFormat('#,###').format(car.price)} ${l10n.egp}',
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<CartCubit>()
                                        .decreaseQuantity(
                                      cartItem,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.remove_circle_outline,
                                  ),
                                ),
                                Text(
                                  '${cartItem.quantity}',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                IconButton(
                                  onPressed: () {
                                    context
                                        .read<CartCubit>()
                                        .increaseQuantity(
                                      cartItem,
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.add_circle_outline,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          context
                              .read<CartCubit>()
                              .deleteCartItem(
                            cartItem.id,
                          );
                        },
                        icon: const Icon(
                          Icons.delete_outline,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: const [
              BoxShadow(
                blurRadius: 8,
                color: Colors.black12,
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    l10n.total,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${NumberFormat('#,###').format(totalPrice)} ${l10n.egp}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () {
                    _confirmOrder(
                      context,
                      cartItems,
                      totalPrice,
                    );
                  },
                  child: Text(
                    l10n.confirmOrder,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _confirmOrder(
      BuildContext context,
      List<CartModel> cartItems,
      double totalPrice,
      ) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return;
    }

    if (cartItems.isEmpty) {
      return;
    }

    final order = OrderModel(
      id: '',
      userId: user.uid,
      carIds: cartItems
          .map((item) => item.carId)
          .toList(),
      totalPrice: totalPrice,
      orderDate: DateTime.now(),
    );

    await context.read<OrderCubit>().addOrder(order);

    for (final item in List.from(cartItems)) {
      await context
          .read<CartCubit>()
          .deleteCartItem(item.id);
    }

    final l10n = AppLocalizations.of(context)!;

    await NotificationService.showNotification(
      title: l10n.orderConfirmedTitle,
      body: l10n.orderCreatedSuccessfully(
        NumberFormat('#,###').format(totalPrice),
        l10n.egp,
      ),
    );

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.orderConfirmedSuccessfully,
        ),
      ),
    );
  }
}