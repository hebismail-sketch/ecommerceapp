import 'package:equatable/equatable.dart';

class OrderEntity extends Equatable {
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

  const OrderEntity({
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

  @override
  List<Object?> get props => [
        id,
        userId,
        carIds,
        totalPrice,
        orderDate,
        paymentMethod,
        paymentStatus,
        firstName,
        lastName,
        phone,
        street,
        buildingNumber,
        floorNumber,
        apartmentNumber,
        additionalNotes,
        latitude,
        longitude,
      ];
}
