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

  final String firstName;
  final String lastName;
  final String phone;
  final String street;
  final String buildingNumber;
  final String floorNumber;
  final String apartmentNumber;
  final String additionalNotes;
  final double latitude;
  final double longitude;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.carIds,
    required this.totalPrice,
    required this.orderDate,
    this.paymentMethod = 'cashOnDelivery',
    this.paymentStatus = 'pending',
    this.firstName = '',
    this.lastName = '',
    this.phone = '',
    this.street = '',
    this.buildingNumber = '',
    this.floorNumber = '',
    this.apartmentNumber = '',
    this.additionalNotes = '',
    this.latitude = 0,
    this.longitude = 0,
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
      firstName: json['firstName'] as String? ?? '',
      lastName: json['lastName'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      street: json['street'] as String? ?? '',
      buildingNumber: json['buildingNumber'] as String? ?? '',
      floorNumber: json['floorNumber'] as String? ?? '',
      apartmentNumber: json['apartmentNumber'] as String? ?? '',
      additionalNotes: json['additionalNotes'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0,
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
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'street': street,
      'buildingNumber': buildingNumber,
      'floorNumber': floorNumber,
      'apartmentNumber': apartmentNumber,
      'additionalNotes': additionalNotes,
      'latitude': latitude,
      'longitude': longitude,
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
      firstName: firstName,
      lastName: lastName,
      phone: phone,
      street: street,
      buildingNumber: buildingNumber,
      floorNumber: floorNumber,
      apartmentNumber: apartmentNumber,
      additionalNotes: additionalNotes,
      latitude: latitude,
      longitude: longitude,
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
      firstName: entity.firstName,
      lastName: entity.lastName,
      phone: entity.phone,
      street: entity.street,
      buildingNumber: entity.buildingNumber,
      floorNumber: entity.floorNumber,
      apartmentNumber: entity.apartmentNumber,
      additionalNotes: entity.additionalNotes,
      latitude: entity.latitude,
      longitude: entity.longitude,
    );
  }
}
