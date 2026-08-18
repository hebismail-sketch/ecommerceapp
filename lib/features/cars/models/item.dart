import 'package:flutter/material.dart';

class Item {
  final String id;
  final String? favoriteId;

  // Arabic
  final String nameAr;
  final String brandAr;
  final String locationAr;
  final String descriptionAr;

  // English
  final String nameEn;
  final String brandEn;
  final String locationEn;
  final String descriptionEn;

  final String image;
  final double price;
  final int year;

  const Item({
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

  factory Item.fromFirestore(
      String id,
      Map<String, dynamic> data,
      ) {
    return Item(
      id: id,
      favoriteId: data['favoriteId'] as String?,

      // New bilingual fields
      nameAr: data['nameAr'] ?? data['name'] ?? '',
      brandAr: data['brandAr'] ?? data['brand'] ?? '',
      locationAr: data['locationAr'] ?? data['location'] ?? '',
      descriptionAr:
      data['descriptionAr'] ?? data['description'] ?? '',

      nameEn: data['nameEn'] ?? data['name'] ?? '',
      brandEn: data['brandEn'] ?? data['brand'] ?? '',
      locationEn: data['locationEn'] ?? data['location'] ?? '',
      descriptionEn:
      data['descriptionEn'] ?? data['description'] ?? '',

      image: data['image'] ?? '',
      price: (data['price'] as num?)?.toDouble() ?? 0,
      year: (data['year'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
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
  String nameFor(Locale locale) {
    return locale.languageCode == 'ar' ? nameAr : nameEn;
  }

  String brandFor(Locale locale) {
    return locale.languageCode == 'ar' ? brandAr : brandEn;
  }

  String locationFor(Locale locale) {
    return locale.languageCode == 'ar' ? locationAr : locationEn;
  }

  String descriptionFor(Locale locale) {
    return locale.languageCode == 'ar'
        ? descriptionAr
        : descriptionEn;
  }

  Item copyWith({
    String? id,
    String? favoriteId,

    String? nameAr,
    String? nameEn,

    String? brandAr,
    String? brandEn,

    String? locationAr,
    String? locationEn,

    String? descriptionAr,
    String? descriptionEn,

    String? image,
    double? price,
    int? year,
  }) {
    return Item(
      id: id ?? this.id,
      favoriteId: favoriteId ?? this.favoriteId,

      nameAr: nameAr ?? this.nameAr,
      nameEn: nameEn ?? this.nameEn,

      brandAr: brandAr ?? this.brandAr,
      brandEn: brandEn ?? this.brandEn,

      locationAr: locationAr ?? this.locationAr,
      locationEn: locationEn ?? this.locationEn,

      descriptionAr: descriptionAr ?? this.descriptionAr,
      descriptionEn: descriptionEn ?? this.descriptionEn,

      image: image ?? this.image,
      price: price ?? this.price,
      year: year ?? this.year,
    );
  }
}