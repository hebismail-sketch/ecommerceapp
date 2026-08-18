import 'package:ecommerceapp/features/admin/screens/manage_cars_screen.dart';
import 'package:ecommerceapp/features/admin/widgets/dashboard_card.dart';
import 'package:ecommerceapp/features/cars/controller/car_cubit.dart';
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
      body: BlocBuilder<CarCubit, CarState>(
        builder: (context, state) {
          if (state is CarLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is CarFailure) {
            return Center(
              child: Text(state.message),
            );
          }

          final carCubit = context.read<CarCubit>();

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              DashboardCard(
                title: l10n.totalCars,
                value: carCubit.totalCars.toString(),
                icon: Icons.directions_car,
                color: Colors.blue,
                onTap: () {},
              ),

              DashboardCard(
                title: l10n.totalBrands,
                value: carCubit.totalBrands.toString(),
                icon: Icons.branding_watermark,
                color: Colors.blue,
                onTap: () {},
              ),

              DashboardCard(
                color: Colors.blue,
                title: l10n.totalPrices,
                value: carCubit.totalPrice.toStringAsFixed(0),
                icon: Icons.attach_money,
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
                    ManageCarsScreen.screenRoute,
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }
}