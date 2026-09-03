import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
  final String id;
  final String userId;
  final List<String> carIds;
  final double totalPrice;
  final DateTime orderDate;
  final String paymentMethod;
  final String paymentStatus;

  const OrderEntity({
    required this.id,
    required this.userId,
    required this.carIds,
    required this.totalPrice,
    required this.orderDate,
    this.paymentMethod = 'cashOnDelivery',
    this.paymentStatus = 'pending',
  });

  @override
  List<Object?> get props => [
    id,
    userId,
    carIds,
    totalPrice,
    orderDate,
    paymentMethod,
    paymentStatus,
  ];
}
