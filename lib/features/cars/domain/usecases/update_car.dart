import '../entities/car_entity.dart';
import '../repositories/car_repository.dart';

class UpdateCar {
  final CarRepository repository;

  UpdateCar(this.repository);

  Future<void> call(String carId, CarEntity car) {
    return repository.updateCar(carId, car);
  }
}
