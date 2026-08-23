import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../manager/favorite_cubit.dart';
import '../../../products/presentation/manager/product_cubit.dart';
import '../../../products/presentation/widgets/product_card.dart';
import '../../../../l10n/app_localizations.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  static const String screenRoute = 'favorites';

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  void initState() {
    super.initState();
    // Load favorites once the screen is initialized
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.read<FavoriteCubit>().loadFavorites(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        centerTitle: true,
      ),
      body: BlocBuilder<FavoriteCubit, FavoriteState>(
        builder: (context, state) {
          // Show loading spinner
          if (state is FavoriteLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          // Show error message if loading fails
          if (state is FavoriteFailure) {
            return Center(child: Text(state.message));
          }

          // Display list of favorite products on success
          if (state is FavoriteSuccess) {
            if (state.favorites.isEmpty) {
              return Center(child: Text(l10n.noFavoriteCars, style: const TextStyle(fontSize: 18)));
            }

            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.favorites.length,
              separatorBuilder: (_, _) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final favorite = state.favorites[index];
                
                // Get the full product details from ProductCubit using the productId
                final product = context.read<ProductCubit>().getProductById(favorite.productId);

                if (product == null) return const SizedBox();

                return ProductCard(
                  product: product,
                  onTap: () {
                    // Navigation to details can be added here
                  },
                );
              },
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
