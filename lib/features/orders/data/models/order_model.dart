import '../../domain/entities/order_entity.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<String> carIds;
  final double totalPrice;
  final DateTime orderDate;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.carIds,
    required this.totalPrice,
    required this.orderDate,
  });

  factory OrderModel.fromJson(String id, Map<String, dynamic> json) {
    return OrderModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      carIds: List<String>.from(json['carIds'] ?? const []),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      orderDate: DateTime.tryParse(json['orderDate'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'carIds': carIds,
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      carIds: carIds,
      totalPrice: totalPrice,
      orderDate: orderDate,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      carIds: entity.carIds,
      totalPrice: entity.totalPrice,
      orderDate: entity.orderDate,
    );
  }
}