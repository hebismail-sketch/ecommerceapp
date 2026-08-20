import 'package:equatable/equatable.dart';
import '../../domain/entities/cart_entity.dart';

part of 'cart_cubit.dart';

abstract class CartState extends Equatable {
  const CartState();

  @override
  List<Object?> get props => [];
}

class CartInitial extends CartState {}

class CartLoading extends CartState {}

class CartSuccess extends CartState {
  final List<CartEntity> cartItems;

  const CartSuccess(this.cartItems);

  @override
  List<Object?> get props => [cartItems];
}

class CartFailure extends CartState {
  final String message;

  const CartFailure(this.message);

  @override
  List<Object?> get props => [message];
}
