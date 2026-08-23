import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class UpdateOrder {
  final OrderRepository repository;

  UpdateOrder(this.repository);

  Future<void> call(OrderEntity order) {
    return repository.updateOrder(order.id, order);
  }
}