import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/favorite_entity.dart';
import '../../domain/usecases/get_favorites.dart';
import '../../domain/usecases/add_favorite.dart';
import '../../domain/usecases/delete_favorite.dart';

part 'favorite_state.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  final GetFavorites getFavoritesUseCase;
  final AddFavorite addFavoriteUseCase;
  final DeleteFavorite deleteFavoriteUseCase;

  FavoriteCubit({
    required this.getFavoritesUseCase,
    required this.addFavoriteUseCase,
    required this.deleteFavoriteUseCase,
  }) : super(FavoriteInitial());

  StreamSubscription? _subscription;
  List<FavoriteEntity> _favorites = [];

  // Fetch all favorite items for a specific user via Stream
  void loadFavorites(String userId) {
    emit(FavoriteLoading());
    _subscription?.cancel();
    _subscription = getFavoritesUseCase.call(userId).listen(
      (favorites) {
        _favorites = favorites;
        emit(FavoriteSuccess(favorites));
      },
      onError: (error) {
        emit(FavoriteFailure(error.toString()));
      },
    );
  }

  // Add or Remove a product from favorites based on its current status
  Future<void> toggleFavorite(String userId, String productId) async {
    final existingFavorite = _getFavoriteByProductId(productId);

    try {
      if (existingFavorite != null) {
        // If the product is already favorited, delete it
        await deleteFavoriteUseCase.call(existingFavorite.id);
      } else {
        // If the product is not favorited, add it
        await addFavoriteUseCase.call(
          userId,
          FavoriteEntity(id: '', productId: productId),
        );
      }
    } catch (e) {
      emit(FavoriteFailure(e.toString()));
    }
  }

  // Check if a product is in the user's favorites list
  bool isFavorite(String productId) {
    return _favorites.any((fav) => fav.productId == productId);
  }

  // Internal helper to find a favorite object by its associated productId
  FavoriteEntity? _getFavoriteByProductId(String productId) {
    try {
      return _favorites.firstWhere((fav) => fav.productId == productId);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
