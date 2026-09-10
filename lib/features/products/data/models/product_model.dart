import '../../domain/entities/product_entity.dart';

class ProductModel extends ProductEntity {
  const ProductModel({
    required super.id,
    super.favoriteId,
    required super.nameAr,
    required super.brandAr,
    super.locationAr = '',
    required super.descriptionAr,
    required super.nameEn,
    required super.brandEn,
    super.locationEn = '',
    required super.descriptionEn,
    required super.image,
    required super.price,
    required super.year,
    super.storeName = '',
    super.latitude,
    super.longitude,
    super.category = '',
  });

  factory ProductModel.fromJson(String id, Map<String, dynamic> json) {
    return ProductModel(
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
      storeName: json['storeName'] as String? ?? '',
      latitude: (json['latitude'] as num?)?.toDouble(),
      longitude: (json['longitude'] as num?)?.toDouble(),
      category: json['category'] as String? ?? _inferCategory(json),
    );
  }

  static String _inferCategory(Map<String, dynamic> json) {
    final raw = [
      json['category'],
      json['brand'],
      json['brandAr'],
      json['brandEn'],
      json['name'],
      json['nameAr'],
      json['nameEn'],
      json['description'],
      json['descriptionAr'],
      json['descriptionEn'],
    ].whereType<String>().join(' ').toLowerCase();

    if (raw.contains('beauty') ||
        raw.contains('تجميل') ||
        raw.contains('مكياج') ||
        raw.contains('عطر') ||
        raw.contains('cream') ||
        raw.contains('perfume')) {
      return 'beauty';
    }
    if (raw.contains('cloth') ||
        raw.contains('ملابس') ||
        raw.contains('dress') ||
        raw.contains('shirt') ||
        raw.contains('قميص') ||
        raw.contains('فستان')) {
      return 'clothing';
    }
    if (raw.contains('watch') ||
        raw.contains('ساع') ||
        raw.contains('rolex') ||
        raw.contains('casio')) {
      return 'watches';
    }
    if (raw.contains('bag') ||
        raw.contains('حقيب') ||
        raw.contains('شنط')) {
      return 'bags';
    }
    if (raw.contains('shoe') ||
        raw.contains('حذاء') ||
        raw.contains('أحذية') ||
        raw.contains('جزمة') ||
        raw.contains('sneaker')) {
      return 'shoes';
    }
    if (raw.contains('game') ||
        raw.contains('لعب') ||
        raw.contains('ألعاب') ||
        raw.contains('playstation') ||
        raw.contains('xbox')) {
      return 'games';
    }
    if (raw.contains('furniture') ||
        raw.contains('أثاث') ||
        raw.contains('chair') ||
        raw.contains('table') ||
        raw.contains('كنب') ||
        raw.contains('طاولة')) {
      return 'furniture';
    }
    if (raw.contains('medicine') ||
        raw.contains('دواء') ||
        raw.contains('أدوية') ||
        raw.contains('صيدل') ||
        raw.contains('pharmacy')) {
      return 'medicine';
    }
    if (raw.contains('accessor') ||
        raw.contains('إكسسوار') ||
        raw.contains('خاتم') ||
        raw.contains('سلسلة') ||
        raw.contains('ring')) {
      return 'accessories';
    }
    return 'cars';
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
      'storeName': storeName,
      'latitude': latitude,
      'longitude': longitude,
      'category': category,
    };
  }
}
