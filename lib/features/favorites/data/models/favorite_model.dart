import '../../domain/entities/favorite_entity.dart';

// Model representing favorite items for data mapping
class FavoriteModel extends FavoriteEntity {
  const FavoriteModel({
    required super.id,
    required super.productId,
  });

  // Convert JSON data from Firebase to FavoriteModel
  factory FavoriteModel.fromJson(String id, Map<String, dynamic> json) {
    return FavoriteModel(
      id: id,
      productId: json['productId'] ?? json['carId'] ?? '',
    );
  }

  // Convert FavoriteModel to Map for storage in Firebase
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
    };
  }
}
