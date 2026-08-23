import '../entities/order_entity.dart';
import '../repositories/order_repository.dart';

class AddOrder {
  final OrderRepository repository;

  AddOrder(this.repository);

  Future<void> call(OrderEntity order) {
    return repository.addOrder(order);
  }
}