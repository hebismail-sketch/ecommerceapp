import '../entities/favorite_entity.dart';
import '../repositories/favorite_repository.dart';

class GetFavorites {
  final FavoriteRepository repository;

  GetFavorites(this.repository);

  // Trigger fetching favorites for a specific user
  Stream<List<FavoriteEntity>> call(String userId) {
    return repository.getFavorites(userId);
  }
}
