import 'package:ecommerceapp/features/orders/presentation/manager/order_cubit.dart';
import 'package:ecommerceapp/features/orders/presentation/widgets/order_card.dart';
import 'package:ecommerceapp/core/widgets/custom_search_app_bar.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  static const String screenRoute = 'orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      context.read<OrderCubit>().loadOrders(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: const CustomSearchAppBar(showBackButton: true),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderFailure) {
            return Center(child: Text(state.message));
          }

          if (state is OrderSuccess) {
            if (state.orders.isEmpty) {
              return Center(
                child: Text(
                  l10n.noOrders,
                  style: const TextStyle(fontSize: 18),
                ),
              );
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.orders.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => OrderCard(
                order: state.orders[index],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}