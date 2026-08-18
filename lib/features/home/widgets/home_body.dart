import 'package:ecommerceapp/features/cars/controller/car_cubit.dart';
import 'package:ecommerceapp/features/cars/widgets/car_card.dart';
import 'package:ecommerceapp/features/favorites/controller/favorite_cubit.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Padding(
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
              suffixIcon: IconButton(
                onPressed: () {
                  context.read<CarCubit>().searchCars('');
                },
                icon: const Icon(Icons.clear),
              ),
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

                if (state is CarSuccess) {
                  if (state.cars.isEmpty) {
                    return Center(
                      child: Text(l10n.noCars),
                    );
                  }

                  final user = FirebaseAuth.instance.currentUser;

                  if (user != null) {
                    context.read<FavoriteCubit>().loadFavorites(
                      user.uid,
                      state.cars,
                    );
                  }

                  return ListView.separated(
                    itemCount: state.cars.length,
                    separatorBuilder: (_, _) =>
                    const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final car = state.cars[index];

                      return CarCard(
                        item: car,
                      );
                    },
                  );
                }

                return const SizedBox();
              },
            ),
          ),
        ],
      ),
    );
  }
}