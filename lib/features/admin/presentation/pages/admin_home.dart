// File: lib/features/admin/presentation/pages/admin_home.dart

import 'package:ecommerceapp/features/admin/presentation/widgets/dashboard_card.dart';
import 'package:ecommerceapp/features/chat/presentation/pages/admin_conversations_page.dart';
import 'package:ecommerceapp/features/orders/presentation/pages/order_screen.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/features/products/presentation/pages/add_product_page.dart';
import 'package:ecommerceapp/features/products/presentation/pages/mange_products_page.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Modern Admin Home Dashboard with stats grid, quick actions, and full management capabilities.
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
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        onTap: onTap,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(
          l10n.adminDashboard,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
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
          final brands = products
              .map((product) => product.brandEn.trim())
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
                          children: const [
                            Text(
                              'Control Center',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              'Manage inventory, customer chats & orders',
                              style: TextStyle(
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
                const Text(
                  'Overview Statistics',
                  style: TextStyle(
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
                      title: l10n.totalCars,
                      value: products.length.toString(),
                      icon: Icons.directions_car,
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
                      icon: Icons.branding_watermark,
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
                      icon: Icons.account_balance_wallet,
                      color: Colors.green.shade700,
                      onTap: () {},
                    ),
                    DashboardCard(
                      title: 'Support Chats',
                      value: 'Active',
                      icon: Icons.chat_bubble_outline,
                      color: Colors.blue.shade600,
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AdminConversationsPage.screenRoute,
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Section Title: Quick Actions
                const Text(
                  'Quick Management Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 12),

                // Action 1: Add New Car
                _buildActionTile(
                  context: context,
                  title: l10n.addCar,
                  subtitle: 'Add a new vehicle to the store inventory',
                  icon: Icons.add_circle_outline,
                  color: Colors.red.shade600,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AddProductPage.screenRoute,
                    );
                  },
                ),

                // Action 2: Manage Cars
                _buildActionTile(
                  context: context,
                  title: l10n.manageCars,
                  subtitle: 'Edit, update prices, or remove cars',
                  icon: Icons.drive_file_rename_outline,
                  color: Colors.deepOrange,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ManageProductsPage.screenRoute,
                    );
                  },
                ),

                // Action 3: Customer Chats
                _buildActionTile(
                  context: context,
                  title: 'Customer Inquiries & Support',
                  subtitle: 'Live chat and support conversation center',
                  icon: Icons.forum_outlined,
                  color: Colors.blue.shade600,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      AdminConversationsPage.screenRoute,
                    );
                  },
                ),

                // Action 4: Customer Orders
                _buildActionTile(
                  context: context,
                  title: l10n.orders,
                  subtitle: 'View and track incoming customer orders',
                  icon: Icons.receipt_long_outlined,
                  color: Colors.purple.shade600,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      OrdersScreen.screenRoute,
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
}

