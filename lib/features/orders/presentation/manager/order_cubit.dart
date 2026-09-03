import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/order_entity.dart';
import '../../domain/usecases/add_order.dart';
import '../../domain/usecases/delete_order.dart';
import '../../domain/usecases/get_orders.dart';
import '../../domain/usecases/update_order.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  final GetOrders getOrdersUseCase;
  final AddOrder addOrderUseCase;
  final UpdateOrder updateOrderUseCase;
  final DeleteOrder deleteOrderUseCase;

  OrderCubit({
    required this.getOrdersUseCase,
    required this.addOrderUseCase,
    required this.updateOrderUseCase,
    required this.deleteOrderUseCase,
  }) : super(const OrderInitial());

  StreamSubscription<List<OrderEntity>>? _subscription;
  List<OrderEntity> orders = [];

  Future<void> loadOrders(String userId) async {
    emit(const OrderLoading());
    await _subscription?.cancel();
    _subscription = getOrdersUseCase.call(userId).listen((items) {
      orders = items;
      emit(OrderSuccess(List.from(orders)));
    }, onError: (error) => emit(OrderFailure(error.toString())));
  }

  Future<void> loadAllOrders() async {
    emit(const OrderLoading());
    await _subscription?.cancel();
    _subscription = getOrdersUseCase.callForAdmin().listen((items) {
      orders = items;
      emit(OrderSuccess(List.from(orders)));
    }, onError: (error) => emit(OrderFailure(error.toString())));
  }

  Future<void> addOrder(OrderEntity order) async {
    try {
      await addOrderUseCase.call(order);
    } catch (e) {
      emit(OrderFailure(e.toString()));
      rethrow;
    }
  }

  Future<void> updateOrder(OrderEntity order) async {
    try {
      await updateOrderUseCase.call(order);
    } catch (e) {
      emit(OrderFailure(e.toString()));
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      await deleteOrderUseCase.call(orderId);
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
