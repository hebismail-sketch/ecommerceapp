import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import 'package:ecommerceapp/features/carts/models/cart_model.dart';

class CartService {
  CartService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _cartCollection =>
      _firestore.collection(AppConstants.cartsCollection);

  Stream<QuerySnapshot<Map<String, dynamic>>> getCartItems(
      String userId,
      ) {
    return _cartCollection
        .where('userId', isEqualTo: userId)
        .snapshots();
  }

  Future<void> addToCart(
      String userId,
      CartModel cartItem,
      ) async {
    await _cartCollection.add({
      ...cartItem.toMap(),
      'userId': userId,
    });
  }

  Future<void> updateCartItem(
      String documentId,
      CartModel cartItem,
      ) async {
    await _cartCollection.doc(documentId).update(
      cartItem.toMap(),
    );
  }

  Future<void> deleteCartItem(
      String documentId,
      ) async {
    await _cartCollection.doc(documentId).delete();
  }
}