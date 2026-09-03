import 'package:ecommerceapp/features/orders/presentation/manager/order_cubit.dart';
import 'package:ecommerceapp/features/orders/presentation/widgets/order_card.dart';
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.read<OrderCubit>().loadOrders(user.uid);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'طلباتي',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
      ),
      body: BlocBuilder<OrderCubit, OrderState>(
        builder: (context, state) {
          if (state is OrderLoading || state is OrderInitial) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is OrderFailure) {
            return _OrdersMessage(
              icon: Icons.cloud_off_outlined,
              title: 'تعذر تحميل الطلبات',
              subtitle: 'تحقق من اتصال الإنترنت ثم حاول مرة أخرى.',
              actionLabel: 'إعادة المحاولة',
              onAction: () {
                final user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  context.read<OrderCubit>().loadOrders(user.uid);
                }
              },
            );
          }

          final orders = (state as OrderSuccess).orders;
          if (orders.isEmpty) {
            return _OrdersMessage(
              icon: Icons.receipt_long_outlined,
              title: l10n.noOrders,
              subtitle: 'عند إتمام طلب جديد سيظهر هنا لتتابع حالته.',
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              final user = FirebaseAuth.instance.currentUser;
              if (user != null) {
                await context.read<OrderCubit>().loadOrders(user.uid);
              }
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 18, 16, 28),
              itemCount: orders.length + 1,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Text(
                    'سجل الطلبات',
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  );
                }
                return OrderCard(order: orders[index - 1]);
              },
            ),
          );
        },
      ),
    );
  }
}

class _OrdersMessage extends StatelessWidget {
  const _OrdersMessage({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: const BoxDecoration(
                color: Color(0xFFFFE9E7),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: const Color(0xFFE64A3D), size: 34),
            ),
            const SizedBox(height: 18),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, height: 1.5),
            ),
            if (onAction != null) ...[
              const SizedBox(height: 20),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
