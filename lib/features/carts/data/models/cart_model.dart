import '../../domain/entities/cart_entity.dart';

class CartModel extends CartEntity {
  const CartModel({
    required super.id,
    required super.productId,
    required super.quantity,
    required super.price,
  });

  // Convert JSON data from Firebase to CartModel object
  factory CartModel.fromJson(String id, Map<String, dynamic> json) {
    return CartModel(
      id: id,
      productId: json['productId'] ?? json['carId'] ?? '',
      quantity: json['quantity'] ?? 1,
      price: (json['price'] as num?)?.toDouble() ?? 0,
    );
  }

  // Convert CartModel object to Map for Firebase storage
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'quantity': quantity,
      'price': price,
    };
  }
}