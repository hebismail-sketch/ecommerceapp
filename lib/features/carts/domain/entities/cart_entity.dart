import 'package:equatable/equatable.dart';

class CartEntity extends Equatable {
  final String id;
  final String productId;
  final int quantity;
  final double price;

  const CartEntity({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.price,
  });

  @override
  List<Object?> get props => [id, productId, quantity, price];
}