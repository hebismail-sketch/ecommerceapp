import '../entities/order_entity.dart';

abstract class OrderRepository {
  Stream<List<OrderEntity>> getOrders(String userId);
  Future<void> addOrder(OrderEntity order);
  Future<void> updateOrder(String orderId, OrderEntity order);
  Future<void> deleteOrder(String orderId);
}