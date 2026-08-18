import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/features/cars/models/item.dart';
import 'package:ecommerceapp/features/favorites/controller/favorite_state.dart';
import 'package:ecommerceapp/features/favorites/models/favorite.model.dart';
import 'package:ecommerceapp/features/favorites/repository/favorite_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FavoriteCubit extends Cubit<FavoriteState> {
  FavoriteCubit() : super(const FavoriteInitial());

  final FavoriteRepository _favoriteRepository = FavoriteRepository();

  final List<Item> _favorites = [];

  final Map<String, String> _favoriteIds = {};

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _subscription;

  List<Item> get favorites => List.unmodifiable(_favorites);

  // =====================================================
  // Load Favorites
  // =====================================================

  void loadFavorites(
      String userId,
      List<Item> cars,
      ) {
    emit(const FavoriteLoading());

    // إلغاء أي Listener قديم
    _subscription?.cancel();

    _subscription = _favoriteRepository
        .getFavorites(userId)
        .listen(
          (snapshot) {
        _favorites.clear();
        _favoriteIds.clear();

        for (final doc in snapshot.docs) {
          final favorite = FavoriteModel.fromMap(
            doc.id,
            doc.data(),
          );

          final index = cars.indexWhere(
                (car) => car.id == favorite.carId,
          );

          if (index != -1) {
            final car = cars[index];

            // إضافة السيارة للمفضلة
            _favorites.add(car);

            // حفظ ID الخاص بوثيقة Firestore
            _favoriteIds[car.id] = doc.id;
          }
        }

        emit(
          FavoriteUpdated(
            List<Item>.from(_favorites),
          ),
        );
      },
      onError: (error) {
        emit(
          FavoriteFailure(
            error.toString(),
          ),
        );
      },
    );
  }

  // =====================================================
  // Add Favorite
  // =====================================================
  Future<void> addToFavorites(
      String userId,
      Item item,
      ) async {
    try {
      // منع التكرار
      if (isFavorite(item.id)) {
        return;
      }

      // الحفظ في Firestore أولًا
      final favoriteId =
      await _favoriteRepository.addFavorite(
        userId,
        FavoriteModel(
          id: '',
          carId: item.id,
        ),
      );

      // بعد نجاح Firestore نضيفها محليًا
      _favorites.add(item);

      // نحفظ document ID
      _favoriteIds[item.id] = favoriteId;

      // تحديث الواجهة
      emit(
        FavoriteUpdated(
          List<Item>.from(_favorites),
        ),
      );
    } catch (e) {
      emit(
        FavoriteFailure(
          e.toString(),
        ),
      );
    }
  }

  // =====================================================
  // Remove Favorite
  // =====================================================

  Future<void> removeFromFavorites(
      String carId,
      ) async {
    try {
      // الحصول على ID وثيقة Firestore
      final favoriteId = _favoriteIds[carId];

      // حذف السيارة من الواجهة مباشرة
      _favorites.removeWhere(
            (car) => car.id == carId,
      );

      // حذف ID الخاص بها من الخريطة
      _favoriteIds.remove(carId);

      // تحديث الواجهة
      emit(
        FavoriteUpdated(
          List<Item>.from(_favorites),
        ),
      );

      // حذفها من Firestore
      if (favoriteId != null) {
        await _favoriteRepository.deleteFavorite(
          favoriteId,
        );
      }
    } catch (e) {
      emit(
        FavoriteFailure(
          e.toString(),
        ),
      );
    }
  }

  // =====================================================
  // Check Favorite
  // =====================================================

  bool isFavorite(String carId) {
    return _favorites.any(
          (car) => car.id == carId,
    );
  }

  // =====================================================
  // Close
  // =====================================================

  @override
  Future<void> close() {
    _subscription?.cancel();

    return super.close();
  }
}