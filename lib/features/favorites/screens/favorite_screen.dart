import 'package:ecommerceapp/features/cars/controller/car_cubit.dart';
import 'package:ecommerceapp/features/cars/widgets/car_card.dart';
import 'package:ecommerceapp/features/favorites/controller/favorite_cubit.dart';
import 'package:ecommerceapp/features/favorites/controller/favorite_state.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  static const String screenRoute = 'favorites';

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  bool _favoritesLoaded = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) return;

      final carCubit = context.read<CarCubit>();

      if (carCubit.cars.isNotEmpty) {
        context.read<FavoriteCubit>().loadFavorites(
          user.uid,
          carCubit.cars,
        );
      }
    });
  }

  void _loadFavorites(
      String userId,
      List cars,
      ) {
    if (_favoritesLoaded) {
      return;
    }

    _favoritesLoaded = true;

    context.read<FavoriteCubit>().loadFavorites(
      userId,
      List.from(cars),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return BlocListener<CarCubit, CarState>(
      listener: (context, state) {
        if (state is CarSuccess) {
          final user = FirebaseAuth.instance.currentUser;

          if (user == null) {
            return;
          }

          _loadFavorites(
            user.uid,
            state.cars,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.favorites),
          centerTitle: true,
        ),
        body: BlocBuilder<FavoriteCubit, FavoriteState>(
          builder: (context, state) {
            if (state is FavoriteLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            if (state is FavoriteFailure) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    state.message,
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }

            if (state is FavoriteUpdated) {
              if (state.favorites.isEmpty) {
                return Center(
                  child: Text(
                    l10n.noFavoriteCars,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                );
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: state.favorites.length,
                itemBuilder: (context, index) {
                  final car = state.favorites[index];

                  return CarCard(
                    item: car,
                  );
                },
                separatorBuilder: (_, _) {
                  return const SizedBox(
                    height: 16,
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}