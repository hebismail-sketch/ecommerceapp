import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/features/cars/models/item.dart';
import 'package:ecommerceapp/features/cars/repository/car_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'car_state.dart';

class CarCubit extends Cubit<CarState> {
  CarCubit() : super(CarInitial()) {
    loadCars();
  }

  final CarRepository _carRepository = CarRepository();

  List<Item> cars = [];

  String selectedBrand = 'الكل';
  String searchText = '';
  String selectedSort = 'default';

  StreamSubscription<QuerySnapshot>? _subscription;

  // =========================
  // Load Cars
  // =========================

  void loadCars() {
    _subscription?.cancel();

    emit(CarLoading());

    _subscription = _carRepository.getCars().listen(
          (snapshot) {
        cars = snapshot.docs.map((doc) {
          return Item.fromFirestore(
            doc.id,
            doc.data() as Map<String, dynamic>,
          );
        }).toList();

        applyFilters();
      },
      onError: (error) {
        emit(CarFailure(error.toString()));
      },
    );
  }

  // =========================
  // CRUD
  // =========================

  Future<void> addCar(Map<String, dynamic> carData) async {
    try {
      await _carRepository.addCar(carData);
    } catch (e) {
      emit(CarFailure(e.toString()));
    }
  }

  Future<void> updateCar(
      String carId,
      Map<String, dynamic> carData,
      ) async {
    try {
      await _carRepository.updateCar(carId, carData);
    } catch (e) {
      emit(CarFailure(e.toString()));
    }
  }

  Future<void> deleteCar(String carId) async {
    try {
      await _carRepository.deleteCar(carId);
    } catch (e) {
      emit(CarFailure(e.toString()));
    }
  }

  // =========================
  // Statistics
  // =========================

  int get totalCars => cars.length;

  Item? getCarById(String carId) {
    try {
      return cars.firstWhere(
            (car) => car.id == carId,
      );
    } catch (e) {
      return null;
    }
  }

  double get totalPrice {
    double total = 0;

    for (final car in cars) {
      total += car.price;
    }

    return total;
  }

  int get totalBrands => cars
      .map((car) => car.brandEn.trim().toLowerCase())
      .where((brand) => brand.isNotEmpty)
      .toSet()
      .length;

  Item? get latestCar {
    if (cars.isEmpty) return null;
    return cars.last;
  }

  List<String> get brands {
    return [
      'الكل',
      ...cars
          .map((car) => car.brandAr)
          .where((brand) => brand.trim().isNotEmpty)
          .toSet(),
    ];
  }

  // =========================
  // Search & Filter
  // =========================

  void searchCars(String text) {
    searchText = text;
    applyFilters();
  }

  void filterByBrand(String brand) {
    selectedBrand = brand;
    applyFilters();
  }

  void sortCars(String sort) {
    selectedSort = sort;
    applyFilters();
  }

  void applyFilters() {
    List<Item> filteredCars = List.from(cars);

    if (searchText.isNotEmpty) {
      final query = searchText.trim().toLowerCase();

      filteredCars = filteredCars.where((car) {
        return car.nameAr.toLowerCase().contains(query) ||
            car.nameEn.toLowerCase().contains(query) ||
            car.brandAr.toLowerCase().contains(query) ||
            car.brandEn.toLowerCase().contains(query) ||
            car.locationAr.toLowerCase().contains(query) ||
            car.locationEn.toLowerCase().contains(query);
      }).toList();
    }

    if (selectedBrand != 'الكل') {
      filteredCars = filteredCars.where((car) {
        return car.brandAr == selectedBrand ||
            car.brandEn == selectedBrand;
      }).toList();
    }

    switch (selectedSort) {
      case 'priceAsc':
        filteredCars.sort(
              (a, b) => a.price.compareTo(b.price),
        );
        break;

      case 'priceDesc':
        filteredCars.sort(
              (a, b) => b.price.compareTo(a.price),
        );
        break;

      case 'yearAsc':
        filteredCars.sort(
              (a, b) => a.year.compareTo(b.year),
        );
        break;

      case 'yearDesc':
        filteredCars.sort(
              (a, b) => b.year.compareTo(a.year),
        );
        break;
    }

    emit(CarSuccess(filteredCars));
  }

  // =========================
  // Close Stream
  // =========================

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}