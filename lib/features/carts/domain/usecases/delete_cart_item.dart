import '../repositories/cart_repository.dart';

class DeleteCartItem {
  final CartRepository repository;

  DeleteCartItem(this.repository);

  // Execute the use case to remove an item from the cart using its ID
  Future<void> call(String cartId) {
    return repository.deleteCartItem(cartId);
  }
}
