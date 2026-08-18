import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/features/favorites/models/favorite.model.dart';
import 'package:ecommerceapp/features/favorites/services/favorite_service.dart';

class FavoriteRepository {
  FavoriteRepository();

  final FavoriteService _favoriteService =
  FavoriteService();

  // =====================================================
  // Get Favorites
  // =====================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getFavorites(
      String userId,
      ) {
    return _favoriteService.getFavorites(
      userId,
    );
  }

  // =====================================================
  // Add Favorite
  // =====================================================

  Future<String> addFavorite(
      String userId,
      FavoriteModel favorite,
      ) async {
    return await _favoriteService.addFavorite(
      userId,
      favorite,
    );
  }

  // =====================================================
  // Delete Favorite
  // =====================================================

  Future<void> deleteFavorite(
      String favoriteId,
      ) async {
    await _favoriteService.deleteFavorite(
      favoriteId,
    );
  }
}