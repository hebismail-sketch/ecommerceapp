import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/constants/app_constants.dart';

class CarService {
  CarService();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _carsCollection =>
      _firestore.collection(AppConstants.productsCollection);

  Stream<QuerySnapshot<Map<String, dynamic>>> getCars() {
    return _carsCollection.orderBy('order').snapshots();
  }

  Future<DocumentReference<Map<String, dynamic>>> addCar(
      Map<String, dynamic> carData,
      ) {
    return _carsCollection.add(carData);
  }

  Future<void> updateCar(
      String carId,
      Map<String, dynamic> carData,
      ) {
    return _carsCollection.doc(carId).update(carData);
  }

  Future<void> deleteCar(String carId) {
    return _carsCollection.doc(carId).delete();
  }
}