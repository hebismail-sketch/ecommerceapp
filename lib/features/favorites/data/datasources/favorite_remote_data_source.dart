import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/favorite_model.dart';

abstract class FavoriteRemoteDataSource {
  // Fetch all favorite items for a specific user
  Stream<List<FavoriteModel>> getFavorites(String userId);

  // Add a product to the user's favorites
  Future<String> addFavorite(String userId, FavoriteModel favorite);

  // Remove a product from the user's favorites
  Future<void> deleteFavorite(String favoriteId);
}

class FavoriteRemoteDataSourceImpl implements FavoriteRemoteDataSource {
  final FirebaseFirestore firestore;

  FavoriteRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<FavoriteModel>> getFavorites(String userId) {
    return firestore
        .collection('favorites')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => FavoriteModel.fromJson(doc.id, doc.data()))
            .toList());
  }

  @override
  Future<String> addFavorite(String userId, FavoriteModel favorite) async {
    final doc = await firestore.collection('favorites').add({
      ...favorite.toJson(),
      'userId': userId,
    });
    return doc.id;
  }

  @override
  Future<void> deleteFavorite(String favoriteId) {
    return firestore.collection('favorites').doc(favoriteId).delete();
  }
}
