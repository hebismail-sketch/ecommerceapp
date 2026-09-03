import '../../domain/entities/order_entity.dart';
import '../../domain/repositories/order_repository.dart';
import '../datasources/order_remote_data_source.dart';
import '../models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource remoteDataSource;

  OrderRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<OrderEntity>> getOrders(String userId) {
    return remoteDataSource.getOrders(userId).map((orders) {
      final entities = orders.map((order) => order.toEntity()).toList();
      entities.sort((a, b) => b.orderDate.compareTo(a.orderDate));
      return entities;
    });
  }

  @override
  Future<void> addOrder(OrderEntity order) {
    return remoteDataSource.addOrder(OrderModel.fromEntity(order));
  }

  @override
  Future<void> updateOrder(String orderId, OrderEntity order) {
    return remoteDataSource.updateOrder(
      orderId,
      OrderModel.fromEntity(order),
    );
  }

  @override
  Future<void> deleteOrder(String orderId) {
    return remoteDataSource.deleteOrder(orderId);
  }
}