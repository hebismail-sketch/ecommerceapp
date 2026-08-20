import '../../domain/entities/car_entity.dart';
import '../../domain/repositories/car_repository.dart';
import '../datasources/car_remote_data_source.dart';
import '../models/car_model.dart';

class CarRepositoryImpl implements CarRepository {
  final CarRemoteDataSource remoteDataSource;

  CarRepositoryImpl({required this.remoteDataSource});

  @override
  Stream<List<CarEntity>> getCars() {
    return remoteDataSource.getCars();
  }

  @override
  Future<void> addCar(CarEntity car) {
    final carModel = CarModel(
      id: car.id,
      favoriteId: car.favoriteId,
      nameAr: car.nameAr,
      brandAr: car.brandAr,
      locationAr: car.locationAr,
      descriptionAr: car.descriptionAr,
      nameEn: car.nameEn,
      brandEn: car.brandEn,
      locationEn: car.locationEn,
      descriptionEn: car.descriptionEn,
      image: car.image,
      price: car.price,
      year: car.year,
    );
    return remoteDataSource.addCar(carModel);
  }

  @override
  Future<void> updateCar(String carId, CarEntity car) {
    final carModel = CarModel(
      id: car.id,
      favoriteId: car.favoriteId,
      nameAr: car.nameAr,
      brandAr: car.brandAr,
      locationAr: car.locationAr,
      descriptionAr: car.descriptionAr,
      nameEn: car.nameEn,
      brandEn: car.brandEn,
      locationEn: car.locationEn,
      descriptionEn: car.descriptionEn,
      image: car.image,
      price: car.price,
      year: car.year,
    );
    return remoteDataSource.updateCar(carId, carModel);
  }

  @override
  Future<void> deleteCar(String carId) {
    return remoteDataSource.deleteCar(carId);
  }
}