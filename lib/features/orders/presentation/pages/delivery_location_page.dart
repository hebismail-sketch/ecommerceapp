import 'dart:convert';

import 'package:ecommerceapp/core/services/location_service.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class DeliveryLocationPage extends StatefulWidget {
  const DeliveryLocationPage({super.key});

  static const String screenRoute = 'deliveryLocation';

  @override
  State<DeliveryLocationPage> createState() => _DeliveryLocationPageState();
}

class _DeliveryLocationPageState extends State<DeliveryLocationPage> {
  final MapController _mapController = MapController();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late LatLng _selectedLocation;
  String _detectedAddress = '';

  bool _isLocating = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _selectedLocation = const LatLng(
      LocationService.defaultLatitude,
      LocationService.defaultLongitude,
    );

    // Auto-detect user's real location quietly on page open if GPS is enabled and permitted
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _autoDetectInitialLocation();
    });
  }

  Future<void> _autoDetectInitialLocation() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) return;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return;
      }

      final position =
          await LocationService.getDeviceGpsPosition(fallbackToCairo: false);
      if (position != null && mounted) {
        final loc = LatLng(position.latitude, position.longitude);
        setState(() {
          _selectedLocation = loc;
        });
        _mapController.move(loc, 17.5);
        _reverseGeocode(loc);
      }
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_detectedAddress.isEmpty) {
      final isAr = Localizations.localeOf(context).languageCode == 'ar';
      _detectedAddress = isAr ? 'القاهرة، مصر' : 'Cairo, Egypt';
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  Future<void> _searchLocation() async {
    final query = _searchController.text.trim();

    if (query.isEmpty || _isSearching) return;

    FocusManager.instance.primaryFocus?.unfocus();

    setState(() => _isSearching = true);

    try {
      final languageCode =
          Localizations.localeOf(context).languageCode;

      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/search',
        {
          'q': query,
          'format': 'jsonv2',
          'limit': '1',
          'countrycodes': 'eg',
          'accept-language': languageCode,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'ecommerceapp-delivery-location/1.0',
          'Accept-Language': languageCode,
        },
      ).timeout(const Duration(seconds: 10));

      if (!mounted) return;

      if (response.statusCode != 200) {
        throw Exception('Search failed');
      }

      final results = jsonDecode(response.body) as List<dynamic>;

      if (results.isEmpty) {
        _showMessage(
          AppLocalizations.of(context)!.locationSearchNotFound,
          isError: true,
        );
        return;
      }

      final result = results.first as Map<String, dynamic>;

      final location = LatLng(
        double.parse(result['lat'] as String),
        double.parse(result['lon'] as String),
      );

      final displayName = result['display_name'] as String? ?? query;

      setState(() {
        _selectedLocation = location;
        _detectedAddress = displayName;
        _searchController.text = displayName;
      });

      _mapController.move(location, 17);

      _showMessage(
        AppLocalizations.of(context)!.locationSelectedSuccessfully,
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!.locationSearchFailed,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isSearching = false);
      }
    }
  }

  Future<void> _reverseGeocode(LatLng point) async {
    try {
      final languageCode = Localizations.localeOf(context).languageCode;
      final uri = Uri.https(
        'nominatim.openstreetmap.org',
        '/reverse',
        {
          'lat': point.latitude.toString(),
          'lon': point.longitude.toString(),
          'format': 'jsonv2',
          'accept-language': languageCode,
        },
      );

      final response = await http.get(
        uri,
        headers: {
          'User-Agent': 'ecommerceapp-delivery-location/1.0',
          'Accept-Language': languageCode,
        },
      ).timeout(const Duration(seconds: 8));

      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        String displayName = '';
        if (data['address'] != null && data['address'] is Map) {
          final addr = data['address'] as Map<String, dynamic>;
          final houseNumber = addr['house_number'] ?? '';
          final road = addr['road'] ?? addr['residential'] ?? addr['suburb'] ?? addr['neighbourhood'] ?? '';
          final city = addr['city'] ?? addr['town'] ?? addr['county'] ?? addr['state'] ?? '';

          final List<String> parts = [];
          if (houseNumber.toString().isNotEmpty) parts.add(houseNumber.toString());
          if (road.toString().isNotEmpty) parts.add(road.toString());
          if (city.toString().isNotEmpty) parts.add(city.toString());

          if (parts.isNotEmpty) {
            displayName = parts.join(', ');
          }
        }
        if (displayName.isEmpty) {
          displayName = data['display_name'] as String? ?? '';
        }

        if (displayName.isNotEmpty) {
          setState(() {
            _detectedAddress = displayName;
            _searchController.text = displayName;
          });
        }
      }
    } catch (_) {}
  }

  Future<void> _useCurrentLocation() async {
    if (_isLocating) return;

    setState(() => _isLocating = true);

    try {
      // 1. Check if device location service (GPS) is enabled on the phone
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) {
        if (!mounted) return;
        await _showEnableGpsDialog();
        return;
      }

      // 2. Check and request location permission
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        await _showPermissionPermanentlyDeniedDialog();
        return;
      }

      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        _showMessage(
          AppLocalizations.of(context)!.locationPermissionRequired,
          isError: true,
        );
        return;
      }

      // 3. Fetch exact device GPS position from hardware sensors
      final rawPosition = await LocationService.getRawDevicePosition();

      if (rawPosition == null) {
        if (!mounted) return;
        _showMessage(
          AppLocalizations.of(context)!.locationError,
          isError: true,
        );
        return;
      }

      // 4. Check if device is an Android emulator with default US/Mountain View coordinates
      if (LocationService.isUsOrEmulatorLocation(
          rawPosition.latitude, rawPosition.longitude)) {
        if (!mounted) return;
        await _showEmulatorNoticeDialog();
        return;
      }

      // 5. This is the user's REAL physical location (building / house level)
      final currentLocation = LatLng(
        rawPosition.latitude,
        rawPosition.longitude,
      );

      setState(() {
        _selectedLocation = currentLocation;
      });

      // Move camera directly to the exact house coordinates with building-level zoom (18.0)
      _mapController.move(currentLocation, 18.0);

      await _reverseGeocode(currentLocation);

      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!.gpsLocationDetected,
      );
    } catch (_) {
      if (!mounted) return;

      _showMessage(
        AppLocalizations.of(context)!.locationError,
        isError: true,
      );
    } finally {
      if (mounted) {
        setState(() => _isLocating = false);
      }
    }
  }

  Future<void> _showEmulatorNoticeDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.devices, color: Colors.blue.shade700),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isAr
                    ? 'تنبيه: أنت تعمل على محاكي (Emulator)'
                    : 'Notice: Running on Android Emulator',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          isAr
              ? 'المحاكي لا يحتوي على شريحة GPS حقيقية، وإحداثياته الافتراضية مضبوطة على كاليفورنيا (أمريكا).\n\n'
                '• على الهاتف الحقيقي: سيحدد الـ GPS موقع منزلك بدقة متناهية فوراً.\n\n'
                '• على المحاكي: يمكنك البحث عن اسم شارعك أو منطقتك في شريط البحث بالأعلى، أو النقر مباشرة على الخريطة لتحديد مكانك بدقة.'
              : 'The emulator has no physical GPS hardware and defaults to California, USA.\n\n'
                '• On a real device: GPS will pinpoint your exact home location accurately.\n\n'
                '• On emulator: Please search your street/area using the search bar above or tap on the map to place your pin.',
          style: const TextStyle(fontSize: 14, height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue.shade700,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(ctx);
              _searchFocusNode.requestFocus();
            },
            icon: const Icon(Icons.search, size: 18),
            label: Text(isAr ? 'البحث عن عنواني' : 'Search Address'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEnableGpsDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.location_off, color: Colors.orange.shade800),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isAr ? 'خدمة الموقع (GPS) مغلقة' : 'Location Service Disabled',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          isAr
              ? 'يرجى تشغيل الـ GPS من إعدادات الهاتف لتتمكن من تحديد موقعك الحالي بدقة.'
              : 'Please enable GPS location service in your device settings to detect your current location.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Geolocator.openLocationSettings();
            },
            child: Text(isAr ? 'تشغيل الـ GPS' : 'Enable GPS'),
          ),
        ],
      ),
    );
  }

  Future<void> _showPermissionPermanentlyDeniedDialog() async {
    final l10n = AppLocalizations.of(context)!;
    final isAr = Localizations.localeOf(context).languageCode == 'ar';

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.security, color: Colors.red),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                isAr ? 'إذن الموقع مطلوب' : 'Location Permission Required',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          isAr
              ? 'تم رفض إذن الوصول إلى الموقع. يرجى تفعيل الإذن من إعدادات التطبيق لتحديد موقعك.'
              : 'Location permission is required to detect your location. Please grant permission in App Settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await Geolocator.openAppSettings();
            },
            child: Text(l10n.openSettings),
          ),
        ],
      ),
    );
  }

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: isError ? Colors.red : Colors.green.shade600,
          content: Text(message),
          behavior: SnackBarBehavior.floating,
        ),
      );
  }

  void _confirmLocation() {
    Navigator.pop(context, _selectedLocation);
  }

  Widget _mapButton({
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
            width: 46,
            height: 46,
            child: Icon(
              icon,
              color: Colors.blueGrey.shade800,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.deliveryLocation,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _selectedLocation,
              initialZoom: 14,
              onTap: (tapPosition, point) {
                setState(() {
                  _selectedLocation = point;
                });
                _reverseGeocode(point);
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName:
                    'com.example.ecommerceapp',
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
                          padding: const EdgeInsets.all(5),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Container(
                            padding: const EdgeInsets.all(9),
                            decoration: BoxDecoration(
                              color: Colors.red.shade600,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ),
                        Container(
                          width: 3,
                          height: 14,
                          color: Colors.red.shade600,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(14),
                    child: TextField(
                      controller: _searchController,
                      focusNode: _searchFocusNode,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _searchLocation(),
                      decoration: InputDecoration(
                        hintText: l10n.searchDeliveryAddress,
                        prefixIcon: _isSearching
                            ? const Padding(
                                padding: EdgeInsets.all(13),
                                child: SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              )
                            : const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                tooltip: l10n.cancel,
                                icon: const Icon(Icons.clear, size: 20),
                                onPressed: () {
                                  _searchController.clear();
                                  setState(() {
                                    _detectedAddress = '';
                                  });
                                },
                              )
                            : IconButton(
                                tooltip: l10n.search,
                                onPressed:
                                    _isSearching ? null : _searchLocation,
                                icon: const Icon(Icons.arrow_forward),
                              ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(14),
                  color: Colors.blue.shade700,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _isLocating ? null : _useCurrentLocation,
                    child: Tooltip(
                      message: l10n.activateGps,
                      child: Container(
                        height: 52,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            _isLocating
                                ? const SizedBox(
                                    width: 18,
                                    height: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.my_location,
                                    color: Colors.white,
                                    size: 22,
                                  ),
                            const SizedBox(width: 6),
                            const Text(
                              'GPS',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            top: 76,
            left: 16,
            right: 16,
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.explore_outlined,
                      color: Colors.blue.shade700,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.gpsOrSearchHint,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            left: 16,
            bottom: 150,
            child: Column(
              children: [
                _mapButton(
                  icon: Icons.add,
                  tooltip: l10n.zoomIn,
                  onPressed: () {
                    _mapController.move(
                      _selectedLocation,
                      (_mapController.camera.zoom + 1)
                          .clamp(3, 19)
                          .toDouble(),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _mapButton(
                  icon: Icons.remove,
                  tooltip: l10n.zoomOut,
                  onPressed: () {
                    _mapController.move(
                      _selectedLocation,
                      (_mapController.camera.zoom - 1)
                          .clamp(3, 19)
                          .toDouble(),
                    );
                  },
                ),
              ],
            ),
          ),

          Positioned(
            right: 16,
            bottom: 150,
            child: FloatingActionButton(
              heroTag: 'delivery_gps_fab',
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
              tooltip: l10n.activateGps,
              onPressed: _isLocating
                  ? null
                  : _useCurrentLocation,
              child: _isLocating
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.my_location),
            ),
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 20,
            child: Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,
                            color: Colors.red.shade600,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _detectedAddress.isNotEmpty
                                    ? _detectedAddress
                                    : l10n.selectedLocation,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                '${_selectedLocation.latitude.toStringAsFixed(5)}, '
                                '${_selectedLocation.longitude.toStringAsFixed(5)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red.shade600,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _confirmLocation,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(
                          l10n.confirmAndSaveLocation,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
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
