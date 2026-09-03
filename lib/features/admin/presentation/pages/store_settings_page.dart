// File: lib/features/admin/presentation/pages/store_settings_page.dart

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerceapp/core/services/location_service.dart';
import 'package:ecommerceapp/core/services/product_translation_service.dart';
import 'package:ecommerceapp/core/services/store_settings_service.dart';
import 'package:ecommerceapp/features/products/presentation/pages/location_picker_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class StoreSettingsPage extends StatefulWidget {
  const StoreSettingsPage({super.key});

  static const String screenRoute = 'storeSettings';

  @override
  State<StoreSettingsPage> createState() => _StoreSettingsPageState();
}

class _StoreSettingsPageState extends State<StoreSettingsPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  String _translatedStoreName = '';
  bool _isTranslating = false;
  int _translationRequest = 0;

  double _latitude = _defaultLatitude;
  double _longitude = _defaultLongitude;
  bool _isLoading = true;
  bool _isSaving = false;
  bool _isGettingLocation = false;
  final MapController _mapController = MapController();

  static const _defaultStoreNameAr = 'المتجر الرئيسي';
  static const _defaultStoreNameEn = 'Main Store';
  static const _defaultLatitude = 30.0444;
  static const _defaultLongitude = 31.2357;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _nameController.clear();
    _translatedStoreName = '';

    try {
      final settings = await StoreSettingsService.getStoreSettings().timeout(
        const Duration(seconds: 10),
      );
      if (!mounted || settings == null) return;

      final savedArabicName = settings.storeNameAr.trim();
      final savedEnglishName = settings.storeNameEn.trim();
      _nameController.text = savedArabicName.isNotEmpty
          ? savedArabicName
          : savedEnglishName;
      _translatedStoreName =
          savedArabicName.isNotEmpty && savedEnglishName != savedArabicName
          ? savedEnglishName
          : '';
      _addressController.text = settings.address;
      if (_hasValidCoordinates(settings.latitude, settings.longitude)) {
        _latitude = settings.latitude;
        _longitude = settings.longitude;
      }
    } catch (_) {
      // Keep the page usable when Firestore is unavailable or slow.
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  bool _hasValidCoordinates(double latitude, double longitude) {
    return latitude.isFinite &&
        longitude.isFinite &&
        latitude >= -90 &&
        latitude <= 90 &&
        longitude >= -180 &&
        longitude <= 180;
  }

  bool _containsArabic(String text) {
    return RegExp(r'[\u0600-\u06FF]').hasMatch(text);
  }

  Future<void> _translateStoreName(String value) async {
    final text = value.trim();
    final request = ++_translationRequest;
    if (text.isEmpty) {
      if (mounted) setState(() => _translatedStoreName = '');
      return;
    }

    setState(() => _isTranslating = true);
    try {
      final translated = await ProductTranslationService.translate(
        text: text,
        fromArabic: _containsArabic(text),
      );
      if (mounted && request == _translationRequest) {
        setState(() {
          _translatedStoreName = translated;
        });
      }
    } catch (_) {
      if (mounted && request == _translationRequest) {
        setState(() {
          _translatedStoreName = '';
        });
      }
    } finally {
      if (mounted && request == _translationRequest) {
        setState(() => _isTranslating = false);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  Future<void> _openMapPicker() async {
    final result = await Navigator.push<LatLng>(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPickerPage(
          initialLatitude: _latitude,
          initialLongitude: _longitude,
        ),
      ),
    );

    if (!mounted || result == null) return;

    setState(() {
      _latitude = result.latitude;
      _longitude = result.longitude;
    });
    _mapController.move(result, 14.0);
  }

  Future<void> _fetchCurrentGPS() async {
    if (_isGettingLocation) return;
    setState(() => _isGettingLocation = true);
    try {
      final pos = await LocationService.getCurrentLocation();
      if (!mounted) return;
      if (pos == null) {
        _showMessage(
          'تعذر تحديد الموقع. تأكد من تفعيل GPS ومنح الصلاحية.',
          isError: true,
        );
        return;
      }
      final newLoc = LatLng(pos.latitude, pos.longitude);
      setState(() {
        _latitude = pos.latitude;
        _longitude = pos.longitude;
      });
      _mapController.move(newLoc, 14.0);
      _showMessage('تم تحديث موقع المتجر بنجاح.');
    } catch (_) {
      if (mounted)
        _showMessage('حدث خطأ أثناء قراءة الموقع الحالي.', isError: true);
    } finally {
      if (mounted) setState(() => _isGettingLocation = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          backgroundColor: isError
              ? Colors.red.shade700
              : Colors.green.shade700,
          content: Text(message),
        ),
      );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(11),
          decoration: BoxDecoration(
            color: color.withOpacity(.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  InputDecoration _fieldDecoration({
    required String label,
    required IconData icon,
    String? hint,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      prefixIcon: Icon(icon, size: 21),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade200),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.blue.shade600, width: 1.5),
      ),
    );
  }

  Future<void> _saveSettings() async {
    if (_isSaving || !_formKey.currentState!.validate()) return;
    FocusManager.instance.primaryFocus?.unfocus();
    if (!_hasValidCoordinates(_latitude, _longitude)) {
      _showMessage('يرجى اختيار موقع صحيح للمتجر.', isError: true);
      return;
    }
    setState(() => _isSaving = true);
    try {
      final enteredName = _nameController.text.trim();
      final hasArabicName = _containsArabic(enteredName);
      final arabicName = enteredName.isEmpty
          ? _defaultStoreNameAr
          : hasArabicName
          ? enteredName
          : _translatedStoreName.trim().isEmpty
          ? _defaultStoreNameAr
          : _translatedStoreName.trim();
      final englishName = enteredName.isEmpty
          ? _defaultStoreNameEn
          : hasArabicName
          ? _translatedStoreName.trim().isEmpty
                ? _defaultStoreNameEn
                : _translatedStoreName.trim()
          : enteredName;

      // The location is saved together with the names; translation failure
      // must never prevent saving valid coordinates.
      await StoreSettingsService.saveStoreSettings(
        StoreSettingsModel(
          storeNameAr: arabicName,
          storeNameEn: englishName,
          latitude: _latitude,
          longitude: _longitude,
          address: _addressController.text.trim(),
        ),
      ).timeout(const Duration(seconds: 20));
      if (!mounted) return;
      _showMessage('تم حفظ إعدادات المتجر بنجاح.');
      Navigator.pop(context);
    } on FirebaseException catch (error) {
      if (!mounted) return;
      final message = switch (error.code) {
        'permission-denied' =>
          'ليس لديك صلاحية لحفظ إعدادات المتجر. راجع قواعد Firestore.',
        'unavailable' => 'خدمة Firestore غير متاحة الآن. تحقق من الإنترنت.',
        'deadline-exceeded' => 'استغرق الحفظ وقتًا طويلًا. حاول مرة أخرى.',
        _ => 'تعذر حفظ الإعدادات: ${error.message ?? error.code}',
      };
      _showMessage(message, isError: true);
    } catch (error) {
      if (mounted) {
        _showMessage('تعذر حفظ الإعدادات: $error', isError: true);
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final storeLocation = LatLng(_latitude, _longitude);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text(
          'إعدادات موقع المتجر',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 920),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 28),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.red.shade400, Colors.red.shade700],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.red.shade200,
                        blurRadius: 14,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.tune_rounded, color: Colors.white, size: 34),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'إدارة بيانات المتجر',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 19,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'حدّث بيانات متجرك وموقعه ليظهر للعملاء بشكل دقيق.',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Store Info Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        icon: Icons.storefront_rounded,
                        title: 'بيانات المتجر الأساسية',
                        subtitle: 'هذه المعلومات تظهر للعملاء داخل التطبيق',
                        color: Colors.red.shade700,
                      ),
                      const SizedBox(height: 18),
                      TextFormField(
                        controller: _nameController,
                        textDirection: TextDirection.rtl,
                        textInputAction: TextInputAction.next,
                        onChanged: (value) {
                          Future<void>.delayed(
                            const Duration(milliseconds: 650),
                            () {
                              if (mounted && value == _nameController.text) {
                                _translateStoreName(value);
                              }
                            },
                          );
                        },
                        decoration: _fieldDecoration(
                          label: 'اسم المتجر',
                          icon: Icons.storefront,
                          hint: 'المتجر الرئيسي',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            _isTranslating ? Icons.sync : Icons.translate,
                            size: 16,
                            color: Colors.blue.shade700,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              _isTranslating
                                  ? 'جاري تجهيز الترجمة تلقائيًا...'
                                  : _translatedStoreName.isEmpty
                                  ? 'سيتم حفظ الاسم باللغتين تلقائيًا'
                                  : 'الترجمة التلقائية: $_translatedStoreName',
                              style: TextStyle(
                                fontSize: 11,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        textDirection: TextDirection.rtl,
                        decoration: _fieldDecoration(
                          label: 'عنوان المتجر بالتفصيل (اختياري)',
                          icon: Icons.location_city_outlined,
                          hint: 'الحي، الشارع، رقم المبنى',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Map & Pin Location Card
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _sectionTitle(
                        icon: Icons.map_outlined,
                        title: 'موقع المتجر على الخريطة',
                        subtitle:
                            'ثبّت الدبوس بدقة حتى يتمكن العملاء من الوصول إليك',
                        color: Colors.blue.shade700,
                      ),
                      const SizedBox(height: 14),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.gps_fixed,
                              size: 17,
                              color: Colors.blue.shade700,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'الإحداثيات الحالية: ${_latitude.toStringAsFixed(5)}, ${_longitude.toStringAsFixed(5)}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Mini Map Preview
                      Container(
                        height: 220,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: FlutterMap(
                          mapController: _mapController,
                          options: MapOptions(
                            initialCenter: storeLocation,
                            initialZoom: 13.0,
                            interactionOptions: const InteractionOptions(
                              flags: InteractiveFlag.none,
                            ),
                          ),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                              userAgentPackageName: 'com.example.ecommerceapp',
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  point: storeLocation,
                                  width: 50,
                                  height: 50,
                                  child: const Icon(
                                    Icons.location_on,
                                    color: Colors.red,
                                    size: 38,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Open interactive map picker button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _openMapPicker,
                          icon: const Icon(Icons.map, size: 20),
                          label: const Text(
                            'تعديل الموقع على الخريطة',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // GPS button
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.blue.shade700,
                            side: BorderSide(color: Colors.blue.shade300),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                          onPressed: _isGettingLocation
                              ? null
                              : _fetchCurrentGPS,
                          icon: _isGettingLocation
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.my_location, size: 18),
                          label: Text(
                            _isGettingLocation
                                ? 'جاري تحديد الموقع...'
                                : 'استخدام موقعي الحالي بالـ GPS',
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Save Button
                SizedBox(
                  height: 56,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 1,
                    ),
                    onPressed: _isSaving ? null : _saveSettings,
                    icon: _isSaving
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.save),
                    label: Text(
                      _isSaving ? 'جاري الحفظ...' : 'حفظ إعدادات المتجر',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'سيتم تطبيق التغييرات فورًا على واجهة العملاء',
                    style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
