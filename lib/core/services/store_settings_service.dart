// File: lib/core/services/store_settings_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class StoreSettingsModel {
  final String storeNameAr;
  final String storeNameEn;
  final double latitude;
  final double longitude;
  final String address;

  const StoreSettingsModel({
    required this.storeNameAr,
    required this.storeNameEn,
    required this.latitude,
    required this.longitude,
    required this.address,
  });

  factory StoreSettingsModel.fromMap(Map<String, dynamic> map) {
    return StoreSettingsModel(
      storeNameAr: map['storeNameAr'] as String? ?? 'المتجر الرئيسي',
      storeNameEn: map['storeNameEn'] as String? ?? 'Main Store',
      latitude: (map['latitude'] as num?)?.toDouble() ?? 30.0444,
      longitude: (map['longitude'] as num?)?.toDouble() ?? 31.2357,
      address: map['address'] as String? ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'storeNameAr': storeNameAr,
      'storeNameEn': storeNameEn,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

class StoreSettingsService {
  static final _firestore = FirebaseFirestore.instance;
  static const String _collection = 'store_settings';
  static const String _document = 'info';

  /// Save store location and info to Firestore
  static Future<void> saveStoreSettings(StoreSettingsModel settings) async {
    await _firestore
        .collection(_collection)
        .doc(_document)
        .set(settings.toMap(), SetOptions(merge: true));
  }

  /// Get store location and info once
  static Future<StoreSettingsModel?> getStoreSettings() async {
    final doc = await _firestore.collection(_collection).doc(_document).get();
    if (doc.exists && doc.data() != null) {
      return StoreSettingsModel.fromMap(doc.data()!);
    }
    return null;
  }

  /// Stream of store settings (auto-update when admin changes location)
  static Stream<StoreSettingsModel?> streamStoreSettings() {
    return _firestore
        .collection(_collection)
        .doc(_document)
        .snapshots()
        .map((doc) {
      if (doc.exists && doc.data() != null) {
        return StoreSettingsModel.fromMap(doc.data()!);
      }
      return null;
    });
  }
}
