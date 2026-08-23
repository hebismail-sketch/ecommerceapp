import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';
import '../models/order_model.dart';

abstract class OrderRemoteDataSource {
  Stream<List<OrderModel>> getOrders(String userId);
  Future<void> addOrder(OrderModel order);
  Future<void> updateOrder(String orderId, OrderModel order);
  Future<void> deleteOrder(String orderId);
}

class OrderRemoteDataSourceImpl implements OrderRemoteDataSource {
  final FirebaseFirestore firestore;

  OrderRemoteDataSourceImpl({required this.firestore});

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      firestore.collection(AppConstants.ordersCollection);

  @override
  Stream<List<OrderModel>> getOrders(String userId) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => OrderModel.fromJson(doc.id, doc.data()))
            .toList());
  }

  @override
  Future<void> addOrder(OrderModel order) async {
    await _ordersCollection.add(order.toJson());
  }

  @override
  Future<void> updateOrder(String orderId, OrderModel order) {
    return _ordersCollection.doc(orderId).update(order.toJson());
  }

  @override
  Future<void> deleteOrder(String orderId) {
    return _ordersCollection.doc(orderId).delete();
  }
}