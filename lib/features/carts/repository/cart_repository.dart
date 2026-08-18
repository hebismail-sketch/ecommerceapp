import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/features/carts/models/cart_model.dart';
import 'package:ecommerceapp/features/carts/services/cart_service.dart';

class CartRepository {
  CartRepository();

  final CartService _cartService = CartService();

  Stream<QuerySnapshot<Map<String, dynamic>>> getCartItems(
      String userId,
      ) {
    return _cartService.getCartItems(userId);
  }

  Future<void> addToCart(
      String userId,
      CartModel cartItem,
      ) async {
    await _cartService.addToCart(
      userId,
      cartItem,
    );
  }

  Future<void> updateCartItem(
      String documentId,
      CartModel cartItem,
      ) async {
    await _cartService.updateCartItem(
      documentId,
      cartItem,
    );
  }

  Future<void> deleteCartItem(
      String documentId,
      ) async {
    await _cartService.deleteCartItem(
      documentId,
    );
  }
}