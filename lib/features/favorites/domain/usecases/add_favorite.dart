import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

class AddFavorite {
  final FavoriteRepository repository;

  AddFavorite(this.repository);

  // Trigger adding a product to the user's favorites
  Future<String> call(String userId, FavoriteEntity favorite) {
    return repository.addFavorite(userId, favorite);
  }
}
