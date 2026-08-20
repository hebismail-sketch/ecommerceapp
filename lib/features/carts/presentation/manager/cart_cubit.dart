import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_entity.dart';
import '../../domain/usecases/get_cart_items.dart';
import '../../domain/usecases/add_to_cart.dart';
import '../../domain/usecases/update_cart_item.dart';
import '../../domain/usecases/delete_cart_item.dart';

part 'cart_state.dart';


class CartCubit extends Cubit<CartState> {
  final GetCartItems getCartItemsUseCase;
  final AddToCart addToCartUseCase;
  final UpdateCartItem updateCartItemUseCase;
  final DeleteCartItem deleteCartItemUseCase;

  CartCubit({
    required this.getCartItemsUseCase,
    required this.addToCartUseCase,
    required this.updateCartItemUseCase,
    required this.deleteCartItemUseCase,
  }) : super(CartInitial());

  StreamSubscription? _subscription;
  List<CartEntity> _cartItems = [];

  // Load cart items for a specific user
  void loadCart(String userId) {
    emit(CartLoading());
    _subscription?.cancel();
    _subscription = getCartItemsUseCase.call(userId).listen(
      (items) {
        _cartItems = items;
        emit(CartSuccess(items));
      },
      onError: (error) {
        emit(CartFailure(error.toString()));
      },
    );
  }

  // Add product to cart
  Future<void> addToCart(String userId, CartEntity cartItem) async {
    try {
      await addToCartUseCase.call(userId, cartItem);
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  // Update item quantity in cart
  Future<void> updateItem(CartEntity cartItem) async {
    try {
      await updateCartItemUseCase.call(cartItem);
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  // Remove item from cart
  Future<void> removeItem(String cartId) async {
    try {
      await deleteCartItemUseCase.call(cartId);
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  // Calculate total price of items in the cart
  double get totalPrice {
    double total = 0;
    for (var item in _cartItems) {
      total += item.price * item.quantity;
    }
    return total;
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
