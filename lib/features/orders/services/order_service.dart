import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';

class OrderService {
  OrderService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _ordersCollection =>
      _firestore.collection(AppConstants.ordersCollection);

  Stream<QuerySnapshot<Map<String, dynamic>>> getOrders(
      String userId,
      ) {
    return _ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('orderDate', descending: true)
        .snapshots();
  }

  Future<DocumentReference<Map<String, dynamic>>> addOrder(
      Map<String, dynamic> orderData,
      ) {
    return _ordersCollection.add(orderData);
  }

  Future<void> updateOrder(
      String orderId,
      Map<String, dynamic> orderData,
      ) {
    return _ordersCollection.doc(orderId).update(orderData);
  }

  Future<void> deleteOrder(String orderId) {
    return _ordersCollection.doc(orderId).delete();
  }
}