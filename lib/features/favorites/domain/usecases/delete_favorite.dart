import '../repositories/favorite_repository.dart';

class DeleteFavorite {
  final FavoriteRepository repository;

  DeleteFavorite(this.repository);

  // Trigger removing an item from favorites using its ID
  Future<void> call(String favoriteId) {
    return repository.deleteFavorite(favoriteId);
  }
}
