import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class AddToCart {
  final CartRepository repository;

  AddToCart(this.repository);

  // Execute the use case to add a new item to the user's cart
  Future<void> call(String userId, CartEntity cartItem) {
    return repository.addToCart(userId, cartItem);
  }
}