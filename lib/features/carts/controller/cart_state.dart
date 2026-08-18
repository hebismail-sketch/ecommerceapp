part of 'cart_cubit.dart';

abstract class CartState {
  const CartState();
}

class CartInitial extends CartState {
  const CartInitial();
}

class CartLoading extends CartState {
  const CartLoading();
}

class CartSuccess extends CartState {
  final List<CartModel> cartItems;

  const CartSuccess(this.cartItems);
}

class CartFailure extends CartState {
  final String message;

  const CartFailure(this.message);
}