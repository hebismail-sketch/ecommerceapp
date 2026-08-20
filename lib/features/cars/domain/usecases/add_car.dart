import '../entities/car_entity.dart';
import '../repositories/car_repository.dart';

class AddCar {
  final CarRepository repository;

  AddCar(this.repository);

  Future<void> call(CarEntity car) {
    return repository.addCar(car);
  }
}