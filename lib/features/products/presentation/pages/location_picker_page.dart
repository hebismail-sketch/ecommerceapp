// File: lib/features/products/presentation/pages/location_picker_page.dart

import 'package:ecommerceapp/core/services/location_service.dart';
import 'package:ecommerceapp/core/widgets/profile_avatar.dart';
import 'package:ecommerceapp/features/profile/presentation/pages/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'dart:convert';

class LocationPickerPage extends StatefulWidget {
  final double? initialLatitude;
  final double? initialLongitude;

  const LocationPickerPage({
    super.key,
    this.initialLatitude,
    this.initialLongitude,
  });

  static const String screenRoute = 'locationPicker';

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  late LatLng _selectedLocation;
  bool _isLocating = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    // Default to Egypt/Cairo if no coords provided
    _selectedLocation = LatLng(
      widget.initialLatitude ?? 30.0444,
      widget.initialLongitude ?? 31.2357,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();
    if (query.isEmpty || _isSearching) return;

    FocusManager.instance.primaryFocus?.unfocus();
    setState(() => _isSearching = true);
    try {
      final uri = Uri.https('nominatim.openstreetmap.org', '/search', {
        'q': query,
        'format': 'jsonv2',
        'limit': '1',
        'countrycodes': 'eg',
      });
      final response = await http
          .get(
            uri,
            headers: {
              'User-Agent': 'ecommerceapp-store-location/1.0',
              'Accept-Language': 'ar',
            },
          )
          .timeout(const Duration(seconds: 10));
      if (!mounted) return;
      if (response.statusCode != 200) throw Exception('Search failed');

      final results = jsonDecode(response.body) as List<dynamic>;
      if (results.isEmpty) {
        _showSearchMessage(
          'لم يتم العثور على هذا العنوان، جرّب كتابة اسم المنطقة والشارع.',
        );
        return;
      }

      final result = results.first as Map<String, dynamic>;
      final location = LatLng(
        double.parse(result['lat'] as String),
        double.parse(result['lon'] as String),
      );
      setState(() => _selectedLocation = location);
      _mapController.move(location, 17.0);
      _showSearchMessage('تم تحديد الموقع على الخريطة بنجاح.');
    } catch (_) {
      if (mounted) {
        _showSearchMessage(
          'تعذر البحث الآن، تحقق من اتصال الإنترنت وحاول مرة أخرى.',
        );
      }
    } finally {
      if (mounted) setState(() => _isSearching = false);
    }
  }

  void _showSearchMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
      );
  }

  Widget _mapControlButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onPressed,
  }) {
    return Material(
      color: Colors.white,
      elevation: 4,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Tooltip(
          message: tooltip,
          child: SizedBox(
            width: 44,
            height: 44,
            child: Icon(icon, color: Colors.blueGrey.shade800, size: 22),
          ),
        ),
      ),
    );
  }

  Future<void> _goToCurrentLocation() async {
    if (_isLocating) return;
    setState(() => _isLocating = true);

    try {
      final pos = await LocationService.getCurrentLocation();
      if (!mounted) return;

      if (pos == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: const Text(
              'تعذر تحديد موقعك. فعّل GPS واسمح للتطبيق بالوصول للموقع.',
            ),
            action: SnackBarAction(
              label: 'الإعدادات',
              textColor: Colors.white,
              onPressed: () async {
                final opened = await Geolocator.openLocationSettings();
                if (!opened) await Geolocator.openAppSettings();
              },
            ),
          ),
        );
        return;
      }

      final newLoc = LatLng(pos.latitude, pos.longitude);
      setState(() => _selectedLocation = newLoc);
      _mapController.move(newLoc, 15.0);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text('حدث خطأ أثناء تحديد موقعك الحالي'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'تحديد موقع المتجر على الخريطة',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: Navigator.canPop(context)
            ? IconButton(
                tooltip: 'رجوع',
                icon: const Icon(Icons.arrow_back_ios_new),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        actions: [
          ProfileAvatar(
            size: 32,
            onTap: () =>
                Navigator.pushNamed(context, ProfileScreen.screenRoute),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.check, color: Colors.green, size: 28),
            tooltip: 'تأكيد الموقع',
            onPressed: () {
              Navigator.pop(context, _selectedLocation);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Detailed OpenStreetMap tiles show roads, buildings, and place names.
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 14.0,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ecommerceapp',
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: _selectedLocation,
                    width: 64,
                    height: 76,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: .22),
                                blurRadius: 7,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.storefront_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 15,
                          color: Colors.red.shade600,
                        ),
                        Container(
                          width: 9,
                          height: 5,
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: .2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Map controls
          Positioned(
            left: 16,
            bottom: 132,
            child: Column(
              children: [
                _mapControlButton(
                  icon: Icons.add,
                  tooltip: 'تكبير الخريطة',
                  onPressed: () => _mapController.move(
                    _selectedLocation,
                    (_mapController.camera.zoom + 1)
                        .clamp(3.0, 19.0)
                        .toDouble(),
                  ),
                ),
                const SizedBox(height: 1),
                _mapControlButton(
                  icon: Icons.remove,
                  tooltip: 'تصغير الخريطة',
                  onPressed: () => _mapController.move(
                    _selectedLocation,
                    (_mapController.camera.zoom - 1)
                        .clamp(3.0, 19.0)
                        .toDouble(),
                  ),
                ),
                const SizedBox(height: 10),
                _mapControlButton(
                  icon: Icons.center_focus_strong_rounded,
                  tooltip: 'إعادة توسيط الخريطة',
                  onPressed: () => _mapController.move(
                    _selectedLocation,
                    _mapController.camera.zoom,
                  ),
                ),
              ],
            ),
          ),

          // Address search field
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(14),
              child: TextField(
                controller: _searchController,
                textDirection: TextDirection.rtl,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => _searchLocation(),
                decoration: InputDecoration(
                  hintText: 'ابحث عن عنوان المتجر بالكامل...',
                  prefixIcon: _isSearching
                      ? const Padding(
                          padding: EdgeInsets.all(13),
                          child: SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        )
                      : const Icon(Icons.search),
                  suffixIcon: IconButton(
                    tooltip: 'بحث',
                    onPressed: _isSearching ? null : _searchLocation,
                    icon: const Icon(Icons.arrow_forward_rounded),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),

          // Instructions Card at Top
          Positioned(
            top: 78,
            left: 16,
            right: 16,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: .12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.touch_app, color: Colors.blue.shade700, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'اضغط على أي مكان بالخريطة لتثبيت الدبوس وتحديد موقع المتجر',
                      style: TextStyle(
                        color: Colors.blueGrey.shade800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Floating GPS Button
          Positioned(
            right: 16,
            bottom: 110,
            child: FloatingActionButton(
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
              elevation: 4,
              onPressed: _isLocating ? null : _goToCurrentLocation,
              child: _isLocating
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          // Bottom Confirmation Card
          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.pin_drop, color: Colors.red, size: 24),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'الموقع المحدد: ${_selectedLocation.latitude.toStringAsFixed(5)}, ${_selectedLocation.longitude.toStringAsFixed(5)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context, _selectedLocation);
                        },
                        icon: const Icon(Icons.check_circle_outline, size: 20),
                        label: const Text(
                          'تأكيد وحفظ موقع المتجر',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
