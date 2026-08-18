part of 'car_cubit.dart';

abstract class CarState {
  const CarState();
}

class CarInitial extends CarState {
  const CarInitial();
}

class CarLoading extends CarState {
  const CarLoading();
}

class CarSuccess extends CarState {
  const CarSuccess(this.cars);

  final List<Item> cars;
}

class CarFailure extends CarState {
  const CarFailure(this.message);

  final String message;
}