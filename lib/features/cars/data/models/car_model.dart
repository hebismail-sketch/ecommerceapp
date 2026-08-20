import '../../domain/entities/car_entity.dart';

class CarModel extends CarEntity {
  const CarModel({
    required super.id,
    super.favoriteId,
    required super.nameAr,
    required super.brandAr,
    required super.locationAr,
    required super.descriptionAr,
    required super.nameEn,
    required super.brandEn,
    required super.locationEn,
    required super.descriptionEn,
    required super.image,
    required super.price,
    required super.year,
  });

  factory CarModel.fromJson(String id, Map<String, dynamic> json) {
    return CarModel(
      id: id,
      favoriteId: json['favoriteId'] as String?,
      nameAr: json['nameAr'] ?? json['name'] ?? '',
      brandAr: json['brandAr'] ?? json['brand'] ?? '',
      locationAr: json['locationAr'] ?? json['location'] ?? '',
      descriptionAr: json['descriptionAr'] ?? json['description'] ?? '',
      nameEn: json['nameEn'] ?? json['name'] ?? '',
      brandEn: json['brandEn'] ?? json['brand'] ?? '',
      locationEn: json['locationEn'] ?? json['location'] ?? '',
      descriptionEn: json['descriptionEn'] ?? json['description'] ?? '',
      image: json['image'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0,
      year: (json['year'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'favoriteId': favoriteId,
      'nameAr': nameAr,
      'nameEn': nameEn,
      'brandAr': brandAr,
      'brandEn': brandEn,
      'locationAr': locationAr,
      'locationEn': locationEn,
      'descriptionAr': descriptionAr,
      'descriptionEn': descriptionEn,
      'image': image,
      'price': price,
      'year': year,
    };
  }
}