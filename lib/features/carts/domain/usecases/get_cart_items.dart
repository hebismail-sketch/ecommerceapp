import '../entities/cart_entity.dart';
import '../repositories/cart_repository.dart';

class GetCartItems {
  final CartRepository repository;

  GetCartItems(this.repository);

  // Execute the use case to fetch cart items for a specific user
  Stream<List<CartEntity>> call(String userId) {
    return repository.getCartItems(userId);
  }
}
