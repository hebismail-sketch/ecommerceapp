import '../entities/favorite_entity.dart';

abstract class FavoriteRepository {
  // Define methods for favorite operations using Entities
  Stream<List<FavoriteEntity>> getFavorites(String userId);
  Future<String> addFavorite(String userId, FavoriteEntity favorite);
  Future<void> deleteFavorite(String favoriteId);
}
