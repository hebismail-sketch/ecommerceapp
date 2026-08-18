import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/features/orders/models/order_model.dart';
import 'package:ecommerceapp/features/orders/services/order_service.dart';

class OrderRepository {
  OrderRepository();

  final OrderService _orderService = OrderService();

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(
      String userId,
      ) {
    return _orderService.getOrders(userId);
  }

  Future<void> addOrder(OrderModel order) async {
    await _orderService.addOrder(order.toMap());
  }

  Future<void> updateOrder(
      String orderId,
      OrderModel order,
      ) async {
    await _orderService.updateOrder(
      orderId,
      order.toMap(),
    );
  }

  Future<void> deleteOrder(String orderId) async {
    await _orderService.deleteOrder(orderId);
  }
}