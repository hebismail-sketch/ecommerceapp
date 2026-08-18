import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/features/orders/models/order_model.dart';
import 'package:ecommerceapp/features/orders/repository/order_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(const OrderInitial());

  final OrderRepository _orderRepository = OrderRepository();

  List<OrderModel> orders = [];

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>?
  _subscription;

  Future<void> loadOrders(String userId) async {
    emit(const OrderLoading());

    await _subscription?.cancel();

    _subscription = _orderRepository.getOrders(userId).listen(
          (snapshot) {
        orders = snapshot.docs.map((doc) {
          return OrderModel.fromMap(
            doc.id,
            doc.data(),
          );
        }).toList();

        emit(OrderSuccess(List.from(orders)));
      },
      onError: (error) {
        emit(OrderFailure(error.toString()));
      },
    );
  }

  Future<void> addOrder(OrderModel order) async {
    try {
      await _orderRepository.addOrder(order);
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await _orderRepository.updateOrder(
        order.id,
        order,
      );
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await _orderRepository.deleteOrder(orderId);
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}