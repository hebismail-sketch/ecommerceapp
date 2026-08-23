import 'package:ecommerceapp/features/admin/widgets/dashboard_card.dart';
import 'package:ecommerceapp/features/products/presentation/manager/product_cubit.dart';
import 'package:ecommerceapp/features/products/presentation/pages/mange_products_page.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHome extends StatelessWidget {
  const AdminHome({super.key});

  static const String screenRoute = 'adminHome';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.adminDashboard),
        centerTitle: true,
      ),
      body: BlocBuilder<ProductCubit, ProductState>(
        builder: (context, state) {
          if (state is ProductLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is ProductFailure) {
            return Center(
              child: Text(state.message),
            );
          }

          if (state is ProductSuccess) {
            final products = state.products;
            final brands = products
                .map((product) => product.brandEn.trim())
                .where((brand) => brand.isNotEmpty)
                .toSet();

            final totalPrice = products.fold<double>(
              0,
              (total, product) => total + product.price,
            );

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                DashboardCard(
                  title: l10n.totalCars,
                  value: products.length.toString(),
                  icon: Icons.directions_car,
                  color: Colors.blue,
                  onTap: () {},
                ),
                DashboardCard(
                  title: l10n.totalBrands,
                  value: brands.length.toString(),
                  icon: Icons.branding_watermark,
                  color: Colors.blue,
                  onTap: () {},
                ),
                DashboardCard(
                  title: l10n.totalPrices,
                  value: totalPrice.toStringAsFixed(0),
                  icon: Icons.attach_money,
                  color: Colors.blue,
                  onTap: () {},
                ),
                DashboardCard(
                  title: l10n.manageCars,
                  value: l10n.open,
                  icon: Icons.settings,
                  color: Colors.blue,
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      ManageProductsPage.screenRoute,
                    );
                  },
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