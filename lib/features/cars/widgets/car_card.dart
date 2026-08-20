import 'package:ecommerceapp/features/cars/models/item.dart';
import 'package:ecommerceapp/features/cars/screens/details_screen.dart';
import 'package:ecommerceapp/features/carts/presentation/manager/cart_cubit.dart';
import 'package:ecommerceapp/features/carts/models/cart_model.dart';
import 'package:ecommerceapp/features/favorites/controller/favorite_cubit.dart';
import 'package:ecommerceapp/features/favorites/controller/favorite_state.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

class CarCard extends StatelessWidget {
  final Item item;

  const CarCard({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context);
    final formattedPrice = NumberFormat('#,###').format(item.price);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DetailsScreen(product: item),
          ),
        );
      },
      child: Card(
        elevation: 6,
        shadowColor: Colors.grey.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 180,
              width: double.infinity,
              child: Image.network(
                item.image,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nameFor(locale),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BlocBuilder<FavoriteCubit, FavoriteState>(
                        builder: (context, state) {
                          final favoriteCubit =
                          context.read<FavoriteCubit>();

                          final isFavorite =
                          favoriteCubit.isFavorite(item.id);

                          return IconButton(
                            onPressed: () async {
                              final user =
                                  FirebaseAuth.instance.currentUser;

                              if (user == null) {
                                return;
                              }

                              if (isFavorite) {
                                await favoriteCubit
                                    .removeFromFavorites(item.id);
                              } else {
                                await favoriteCubit.addToFavorites(
                                  user.uid,
                                  item,
                                );
                              }
                            },
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite
                                  ? Colors.red
                                  : Colors.grey,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        onPressed: () {
                          final user =
                              FirebaseAuth.instance.currentUser;

                          if (user == null) {
                            return;
                          }

                          final cartItem = CartModel(
                            id: '',
                            carId: item.id,
                            quantity: 1,
                            price: item.price,
                          );

                          context.read<CartCubit>().addToCart(
                            user.uid,
                            cartItem,
                          );
                        },
                        icon: const Icon(
                          Icons.add_shopping_cart,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xffEAEFF2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      item.year.toString(),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '$formattedPrice ${l10n.egp}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}