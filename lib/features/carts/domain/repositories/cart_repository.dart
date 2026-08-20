import '../entities/cart_entity.dart';

abstract class CartRepository {
  // Define methods for cart operations using Entities
  Stream<List<CartEntity>> getCartItems(String userId);

  // Add a product to the cart for a specific user
  Future<void> addToCart(String userId, CartEntity cartItem);

  // Update details like quantity of a cart item
  Future<void> updateCartItem(CartEntity cartItem);

  // Remove an item from the cart using its ID
  Future<void> deleteCartItem(String cartId);
}