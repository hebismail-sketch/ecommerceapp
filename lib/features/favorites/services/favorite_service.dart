import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/features/favorites/models/favorite.model.dart';

class FavoriteService {
  FavoriteService();

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>>
  get _favoritesCollection =>
      _firestore.collection(
        AppConstants.favoritesCollection,
      );

  // =====================================================
  // Get Favorites
  // =====================================================

  Stream<QuerySnapshot<Map<String, dynamic>>> getFavorites(
      String userId,
      ) {
    return _favoritesCollection
        .where(
      'userId',
      isEqualTo: userId,
    )
        .snapshots();
  }

  // =====================================================
  // Add Favorite
  // =====================================================

  Future<String> addFavorite(
      String userId,
      FavoriteModel favorite,
      ) async {
    final doc = await _favoritesCollection.add({
      ...favorite.toMap(),
      'userId': userId,
    });

    return doc.id;
  }

  // =====================================================
  // Delete Favorite
  // =====================================================

  Future<void> deleteFavorite(
      String favoriteId,
      ) async {
    await _favoritesCollection
        .doc(favoriteId)
        .delete();
  }
}