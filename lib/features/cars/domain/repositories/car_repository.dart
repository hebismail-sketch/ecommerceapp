import '../entities/car_entity.dart';

abstract class CarRepository {
  Stream<List<CarEntity>> getCars();
  Future<void> addCar(CarEntity car);
  Future<void> updateCar(String carId, CarEntity car);
  Future<void> deleteCar(String carId);
}