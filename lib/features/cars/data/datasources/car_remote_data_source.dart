import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/car_model.dart';

abstract class CarRemoteDataSource {
  Stream<List<CarModel>> getCars();
  Future<void> addCar(CarModel carModel);
  Future<void> updateCar(String carId, CarModel carModel);
  Future<void> deleteCar(String carId);
}

class CarRemoteDataSourceImpl implements CarRemoteDataSource {
  final FirebaseFirestore firestore;

  CarRemoteDataSourceImpl({required this.firestore});

  @override
  Stream<List<CarModel>> getCars() {
    return firestore
        .collection('products')
        .orderBy('year', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => CarModel.fromJson(doc.id, doc.data()))
        .toList());
  }

  @override
  Future<void> addCar(CarModel carModel) {
    return firestore.collection('products').add(carModel.toJson());
  }

  @override
  Future<void> updateCar(String carId, CarModel carModel) {
    return firestore.collection('products').doc(carId).update(carModel.toJson());
  }

  @override
  Future<void> deleteCar(String carId) {
    return firestore.collection('products').doc(carId).delete();
  }
}