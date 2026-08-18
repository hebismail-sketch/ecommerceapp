import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/features/cars/services/car_service.dart';

class CarRepository {
  CarRepository();

  final CarService _carService = CarService();

  Stream<QuerySnapshot> getCars() => _carService.getCars();

  Future<void> addCar(Map<String, dynamic> carData) =>
      _carService.addCar(carData);

  Future<void> updateCar(
      String carId,
      Map<String, dynamic> carData,
      ) =>
      _carService.updateCar(carId, carData);

  Future<void> deleteCar(String carId) =>
      _carService.deleteCar(carId);
}