part of 'order_cubit.dart';

abstract class OrderState {
  const OrderState();
}

class OrderInitial extends OrderState {
  const OrderInitial();
}

class OrderLoading extends OrderState {
  const OrderLoading();
}

class OrderSuccess extends OrderState {
  final List<OrderModel> orders;

  const OrderSuccess(this.orders);
}

class OrderFailure extends OrderState {
  final String message;

  const OrderFailure(this.message);
}