import 'package:ecommerceapp/core/utils/app_dialogs.dart';
import 'package:ecommerceapp/core/utils/app_snackbar.dart';
import 'package:ecommerceapp/features/admin/screens/add_cars_screen.dart';
import 'package:ecommerceapp/features/admin/widgets/manage_car_card.dart';
import 'package:ecommerceapp/features/cars/controller/car_cubit.dart';
import 'package:ecommerceapp/features/cars/models/item.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ManageCarsScreen extends StatelessWidget {
  const ManageCarsScreen({super.key});

  static const String screenRoute = 'manageCars';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.manageCars),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(
            context,
            AddCarScreen.screenRoute,
          );
        },
        child: const Icon(Icons.add),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              onChanged: (value) {
                context.read<CarCubit>().searchCars(value);
              },
              decoration: InputDecoration(
                hintText: l10n.searchForCar,
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: BlocBuilder<CarCubit, CarState>(
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

                  if (state is! CarSuccess) {
                    return const SizedBox();
                  }

                  final List<Item> cars = state.cars;

                  if (cars.isEmpty) {
                    return Center(
                      child: Text(
                        l10n.noCars,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: cars.length,
                    itemBuilder: (context, index) {
                      final car = cars[index];

                      return ManageCarCard(
                        car: car,

                        onEdit: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => AddCarScreen(
                                car: car,
                              ),
                            ),
                          );
                        },

                        onDelete: () async {
                          final result =
                          await AppDialogs.confirmDelete(
                            context,
                            title: l10n.deleteCar,
                            message: l10n.deleteCarConfirmation,
                          );

                          if (!result) return;

                          await context
                              .read<CarCubit>()
                              .deleteCar(car.id);

                          if (context.mounted) {
                            AppSnackBar.success(
                              context,
                              l10n.carDeletedSuccessfully,
                            );
                          }
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}