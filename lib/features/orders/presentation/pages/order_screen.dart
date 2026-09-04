import 'package:ecommerceapp/core/widgets/profile_avatar.dart';
import 'package:ecommerceapp/features/orders/presentation/manager/order_cubit.dart';
import 'package:ecommerceapp/features/orders/presentation/widgets/order_card.dart';
import 'package:ecommerceapp/features/profile/presentation/pages/profile_screen.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OrdersScreen extends StatefulWidget {
  final bool adminMode;

  const OrdersScreen({super.key, this.adminMode = false});

  static const String screenRoute = 'orders';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  void initState() {
    super.initState();

    final user = FirebaseAuth.instance.currentUser;

    if (widget.adminMode || user != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (widget.adminMode) {
          context.read<OrderCubit>().loadAllOrders();
        } else {
          context.read<OrderCubit>().loadOrders(user!.uid);
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
        automaticallyImplyLeading: false,
        leadingWidth: 56,
        title: Text(
          widget.adminMode ? 'طلبات العملاء' : 'طلباتي',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        leading: widget.adminMode
            ? IconButton(
                tooltip: 'رجوع إلى لوحة الإدارة',
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  }
                },
              )
            : null,
        actions: widget.adminMode
            ? [
                Padding(
                  padding: const EdgeInsetsDirectional.only(end: 12),
                  child: ProfileAvatar(
                    size: 32,
                    onTap: () =>
                        Navigator.pushNamed(context, ProfileScreen.screenRoute),
                  ),
                ),
              ]
            : null,
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
                if (widget.adminMode) {
                  context.read<OrderCubit>().loadAllOrders();
                } else if (user != null) {
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
              if (widget.adminMode) {
                await context.read<OrderCubit>().loadAllOrders();
              } else if (user != null) {
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
                    widget.adminMode ? 'طلبات العملاء الواردة' : 'سجل الطلبات',
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
