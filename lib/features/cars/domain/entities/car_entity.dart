import 'package:equatable/equatable.dart';

class CarEntity extends Equatable {
  final String id;
  final String? favoriteId;

  // Arabic Fields
  final String nameAr;
  final String brandAr;
  final String locationAr;
  final String descriptionAr;

  // English Fields
  final String nameEn;
  final String brandEn;
  final String locationEn;
  final String descriptionEn;

  final String image;
  final double price;
  final int year;

  const CarEntity({
    required this.id,
    this.favoriteId,
    required this.nameAr,
    required this.brandAr,
    required this.locationAr,
    required this.descriptionAr,
    required this.nameEn,
    required this.brandEn,
    required this.locationEn,
    required this.descriptionEn,
    required this.image,
    required this.price,
    required this.year,
  });

  @override
  List<Object?> get props => [
    id,
    favoriteId,
    nameAr,
    brandAr,
    locationAr,
    descriptionAr,
    nameEn,
    brandEn,
    locationEn,
    descriptionEn,
    image,
    price,
    year,
  ];
}