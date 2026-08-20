import '../entities/car_entity.dart';
import '../repositories/car_repository.dart';

class GetCars {
  final CarRepository repository;

  GetCars(this.repository);

  Stream<List<CarEntity>> call() {
    return repository.getCars();
  }
}