class CartModel {
  final String id;
  final String carId;
  final int quantity;
  final double price;

  const CartModel({
    required this.id,
    required this.carId,
    required this.quantity,
    required this.price,
  });

  CartModel copyWith({
    String? id,
    String? carId,
    int? quantity,
    double? price,
  }) {
    return CartModel(
      id: id ?? this.id,
      carId: carId ?? this.carId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'carId': carId,
      'quantity': quantity,
      'price': price,
    };
  }

  factory CartModel.fromMap(
      String id,
      Map<String, dynamic> data,
      ) {
    return CartModel(
      id: id,
      carId: data['carId'] ?? '',
      quantity: data['quantity'] ?? 1,
      price: (data['price'] as num?)?.toDouble() ?? 0,
    );
  }
}