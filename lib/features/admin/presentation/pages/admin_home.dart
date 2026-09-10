// File: lib/features/admin/presentation/pages/admin_home.dart

import 'package:ecommerceapp/core/theme/app_colors.dart';
import 'package:ecommerceapp/features/admin/presentation/widgets/dashboard_card.dart';
import 'package:ecommerceapp/features/admin/presentation/pages/store_settings_page.dart';
import 'package:ecommerceapp/features/chat/presentation/pages/admin_conversations_page.dart';
import 'package:ecommerceapp/features/notifications/presentation/pages/notifications_page.dart';
import 'package:ecommerceapp/features/orders/presentation/pages/order_screen.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/features/products/presentation/pages/add_product_page.dart';
import 'package:ecommerceapp/features/products/presentation/pages/mange_products_page.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Modern Admin Home Dashboard with stats grid, quick actions, and full bilingual support.
class AdminHome extends StatefulWidget {
  const AdminHome({super.key});

  static const String screenRoute = 'adminHome';

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ProductCubit>().loadProducts();
    });
  }

  Widget _buildActionTile({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : Colors.grey.shade100,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.3)
                : Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        type: MaterialType.transparency,
        borderRadius: BorderRadius.circular(16),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          onTap: onTap,
          leading: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isDark ? Colors.white : Colors.black87,
            ),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(
              fontSize: 12,
              color: isDark ? AppColors.darkTextSecondary : Colors.grey.shade600,
            ),
          ),
          trailing: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.grey.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              size: 14,
              color: isDark ? AppColors.gold : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          l10n.adminDashboard,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : Colors.black87,
          ),
        ),
        centerTitle: false,
        elevation: 0,
        backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
        actions: [
          StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: _unreadNotificationsStream(),
            builder: (context, snapshot) {
              final hasUnread = (snapshot.data?.docs.length ?? 0) > 0;
              return IconButton(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Icon(
                      Icons.notifications_outlined,
                      color: isDark ? AppColors.gold : Colors.black87,
                    ),
                    if (hasUnread)
                      Positioned(
                        top: -1,
                        right: -1,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const NotificationsPage(),
                      settings: const RouteSettings(
                        name: NotificationsPage.screenRoute,
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is ProductFailure) {
            return Center(
              child: Text(
                state.message,
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final products = state is ProductSuccess ? state.products : [];
          final isArabic = Localizations.localeOf(context).languageCode == 'ar';
          final brands = products
              .map(
                (product) =>
                    (isArabic ? product.brandAr : product.brandEn).trim(),
              )
              .where((brand) => brand.isNotEmpty)
              .toSet();

          final totalPrice = products.fold<double>(
            0,
            (total, product) => total + product.price,
          );

          return RefreshIndicator(
            onRefresh: () async {
              context.read<ProductCubit>().loadProducts();
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Top Admin Banner with theme gradient
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade200,
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.admin_panel_settings,
                          color: Colors.white,
                          size: 36,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.controlCenter,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              l10n.adminSubtitle,
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Section Title: Quick Statistics
                Text(
                  l10n.overviewStats,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // 2x2 Stats Cards Grid
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.15,
                  children: [
                    DashboardCard(
                      title: l10n.totalProducts,
                      value: products.length.toString(),
                      icon: Icons.inventory_2_outlined,
                      color: Colors.red.shade600,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ManageProductsPage.screenRoute,
                        );
                      },
                    ),
                    DashboardCard(
                      title: l10n.totalBrands,
                      value: brands.length.toString(),
                      icon: Icons.category_outlined,
                      color: Colors.deepOrange,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          ManageProductsPage.screenRoute,
                        );
                      },
                    ),
                    DashboardCard(
                      title: l10n.totalPrices,
                      value: '${totalPrice.toStringAsFixed(0)} ${l10n.egp}',
                      icon: Icons.account_balance_wallet_outlined,
                      color: Colors.green.shade700,
                      onTap: () {},
                    ),
                    DashboardCard(
                      title: l10n.supportChats,
                      value: l10n.active,
                      icon: Icons.chat_bubble_outline,
                      color: Colors.blue.shade600,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AdminConversationsPage(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section Title: Quick Actions
                Text(
                  l10n.quickActions,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Action 1: Add New Product
                _buildActionTile(
                  context: context,
                  title: l10n.addProduct,
                  subtitle: l10n.addProductSubtitle,
                  icon: Icons.add_circle_outline,
                  color: Colors.red.shade600,
                  onTap: () {
                    Navigator.pushNamed(context, AddProductPage.screenRoute);
                  },
                ),

                // Action 2: Manage Products
                _buildActionTile(
                  context: context,
                  title: l10n.manageProducts,
                  subtitle: l10n.manageProductsSubtitle,
                  icon: Icons.drive_file_rename_outline,
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ManageProductsPage.screenRoute,
                    );
                  },
                ),

                // Action 3: Store Location
                _buildActionTile(
                  context: context,
                  title: l10n.storeLocation,
                  subtitle: l10n.storeLocationSubtitle,
                  icon: Icons.location_on_outlined,
                  color: Colors.teal.shade600,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const StoreSettingsPage(),
                      ),
                    );
                  },
                ),

                // Action 4: Customer Chats
                _buildActionTile(
                  context: context,
                  title: l10n.customerChats,
                  subtitle: l10n.customerChatsSubtitle,
                  icon: Icons.forum_outlined,
                  color: Colors.blue.shade600,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AdminConversationsPage(),
                      ),
                    );
                  },
                ),

                // Action 5: Customer Orders
                _buildActionTile(
                  context: context,
                  title: l10n.orders,
                  subtitle: l10n.customerOrdersSubtitle,
                  icon: Icons.receipt_long_outlined,
                  color: Colors.purple.shade600,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const OrdersScreen(adminMode: true),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _unreadNotificationsStream() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return const Stream.empty();
    }

    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('notifications')
        .where('read', isEqualTo: false)
        .snapshots();
  }
}
