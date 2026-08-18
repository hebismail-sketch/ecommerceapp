import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/features/carts/models/cart_model.dart';
import 'package:ecommerceapp/features/carts/repository/cart_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartInitial());

  final CartRepository _cartRepository = CartRepository();

  List<CartModel> cartItems = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;

  void loadCart(String userId) {
    emit(const CartLoading());

    _subscription?.cancel();

    _subscription = _cartRepository.getCartItems(userId).listen(
          (snapshot) {
        cartItems = snapshot.docs.map((doc) {
          return CartModel.fromMap(
            doc.id,
            doc.data(),
          );
        }).toList();

        emit(CartSuccess(List.from(cartItems)));
      },
      onError: (error) {
        emit(CartFailure(error.toString()));
      },
    );
  }

  Future<void> addToCart(
      String userId,
      CartModel cartItem,
      ) async {
    try {
      await _cartRepository.addToCart(
        userId,
        cartItem,
      );
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> updateCartItem(
      String documentId,
      CartModel cartItem,
      ) async {
    try {
      await _cartRepository.updateCartItem(
        documentId,
        cartItem,
      );
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> deleteCartItem(
      String documentId,
      ) async {
    try {
      await _cartRepository.deleteCartItem(
        documentId,
      );
    } catch (e) {
      emit(CartFailure(e.toString()));
    }
  }

  Future<void> increaseQuantity(
      CartModel cartItem,
      ) async {
    final updatedItem = cartItem.copyWith(
      quantity: cartItem.quantity + 1,
    );

    await updateCartItem(
      cartItem.id,
      updatedItem,
    );
  }

  Future<void> decreaseQuantity(
      CartModel cartItem,
      ) async {
    if (cartItem.quantity <= 1) {
      await deleteCartItem(cartItem.id);
      return;
    }

    final updatedItem = cartItem.copyWith(
      quantity: cartItem.quantity - 1,
    );

    await updateCartItem(
      cartItem.id,
      updatedItem,
    );
  }

  int get totalItems {
    int total = 0;

    for (final item in cartItems) {
      total += item.quantity;
    }

    return total;
  }
  double get totalPrice {
    double total = 0;

    for (final item in cartItems) {
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