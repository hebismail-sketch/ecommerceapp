import 'package:cloud_firestore/cloud_firestore.dart';

import '../../domain/entities/order_entity.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<String> carIds;
  final double totalPrice;
  final DateTime orderDate;
  final String paymentMethod;
  final String paymentStatus;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.carIds,
    required this.totalPrice,
    required this.orderDate,
    this.paymentMethod = 'cashOnDelivery',
    this.paymentStatus = 'pending',
  });

  factory OrderModel.fromJson(String id, Map<String, dynamic> json) {
    return OrderModel(
      id: id,
      userId: json['userId'] as String? ?? '',
      carIds: List<String>.from(json['carIds'] ?? const []),
      totalPrice: (json['totalPrice'] as num?)?.toDouble() ?? 0,
      orderDate: _parseOrderDate(json['orderDate']),
      paymentMethod: json['paymentMethod'] as String? ?? 'cashOnDelivery',
      paymentStatus: json['paymentStatus'] as String? ?? 'pending',
    );
  }

  static DateTime _parseOrderDate(dynamic value) {
    if (value is Timestamp) return value.toDate();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
    return DateTime.now();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'carIds': carIds,
      'totalPrice': totalPrice,
      'orderDate': orderDate.toIso8601String(),
      'paymentMethod': paymentMethod,
      'paymentStatus': paymentStatus,
    };
  }

  OrderEntity toEntity() {
    return OrderEntity(
      id: id,
      userId: userId,
      carIds: carIds,
      totalPrice: totalPrice,
      orderDate: orderDate,
      paymentMethod: paymentMethod,
      paymentStatus: paymentStatus,
    );
  }

  factory OrderModel.fromEntity(OrderEntity entity) {
    return OrderModel(
      id: entity.id,
      userId: entity.userId,
      carIds: entity.carIds,
      totalPrice: entity.totalPrice,
      orderDate: entity.orderDate,
      paymentMethod: entity.paymentMethod,
      paymentStatus: entity.paymentStatus,
    );
  }
}
