import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class UpdateCartItem {
  final CartRepository repository;

  UpdateCartItem(this.repository);

  // Execute the use case to update an existing cart item (e.g., quantity)
  Future<void> call(CartEntity cartItem) {
    return repository.updateCartItem(cartItem);
  }
}
