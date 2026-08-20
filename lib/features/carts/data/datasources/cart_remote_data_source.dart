import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/cart_model.dart';

abstract class CartRemoteDataSource {
  // Get all cart items for a specific user
  Stream<List<CartModel>> getCartItems(String userId);

  // Add a new product to the cart
  Future<void> addToCart(String userId, CartModel cartItem);

  // Update existing cart item quantity or details
  Future<void> updateCartItem(CartModel cartItem);

  // Remove an item from the cart
  Future<void> deleteCartItem(String cartId);
}

class CartRemoteDataSourceImpl implements CartRemoteDataSource {
  final FirebaseFirestore firestore;

  CartRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<CartModel>> getCartItems(String userId) {
    return firestore
        .collection('carts')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CartModel.fromJson(doc.id, doc.data()))
        .toList());
  }

  @override
  Future<void> addToCart(String userId, CartModel cartItem) {
    return firestore.collection('carts').add({
      ...cartItem.toJson(),
      'userId': userId,
    });
  }

  @override
  Future<void> updateCartItem(CartModel cartItem) {
    return firestore.collection('carts').doc(cartItem.id).update(cartItem.toJson());
  }

  @override
  Future<void> deleteCartItem(String cartId) {
    return firestore.collection('carts').doc(cartId).delete();
  }
}