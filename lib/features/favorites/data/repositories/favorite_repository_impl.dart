import '../../domain/entities/favorite_entity.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../datasources/favorite_remote_data_source.dart';
import '../models/favorite_model.dart';

class FavoriteRepositoryImpl implements FavoriteRepository {
  final FavoriteRemoteDataSource remoteDataSource;

  FavoriteRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<FavoriteEntity>> getFavorites(String userId) {
    // Map favorite models from data source to entities
    return remoteDataSource.getFavorites(userId);
  }

  @override
  Future<String> addFavorite(String userId, FavoriteEntity favorite) {
    // Convert entity to model before adding
    final favoriteModel = FavoriteModel(
      id: favorite.id,
      productId: favorite.productId,
    );
    return remoteDataSource.addFavorite(userId, favoriteModel);
  }

  @override
  Future<void> deleteFavorite(String favoriteId) {
    // Directly delete using the ID
    return remoteDataSource.deleteFavorite(favoriteId);
  }
}
