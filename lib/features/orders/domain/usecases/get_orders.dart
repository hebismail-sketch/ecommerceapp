import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class GetOrders {
  final OrderRepository repository;

  GetOrders(this.repository);

  Stream<List<OrderEntity>> call(String userId) {
    return repository.getOrders(userId);
  }
}