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

  late LatLng _selectedLocation;
  String _detectedAddress = '';

  bool _isLocating = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _selectedLocation = const LatLng(
      30.0444,
      31.2357,
    );

    _checkInitialLocation();
  }

  Future<void> _checkInitialLocation() async {
    try {
      final isServiceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isServiceEnabled) return;

      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse) {
        _useCurrentLocation();
      }
    } catch (_) {}
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
      ).timeout(const Duration(seconds: 6));

      if (response.statusCode == 200 && mounted) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final displayName = data['display_name'] as String?;
        if (displayName != null && displayName.isNotEmpty) {
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
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (!mounted) return;
        _showEnableGpsMessage();
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          if (!mounted) return;
          _showLocationPermissionMessage();
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        if (!mounted) return;
        _showLocationPermissionMessage(isPermanentlyDenied: true);
        return;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (_) {
        position = await LocationService.getCurrentLocation();
      }

      if (!mounted) return;

      if (position == null) {
        _showMessage(
          AppLocalizations.of(context)!.locationError,
          isError: true,
        );
        return;
      }

      final currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _selectedLocation = currentLocation;
      });

      _mapController.move(currentLocation, 17.5);

      _reverseGeocode(currentLocation);

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

  void _showEnableGpsMessage() {
    final l10n = AppLocalizations.of(context)!;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.orange.shade800,
          behavior: SnackBarBehavior.floating,
          content: Text(l10n.enableGpsToLocate),
          action: SnackBarAction(
            label: l10n.activateGps,
            textColor: Colors.white,
            onPressed: () async {
              await Geolocator.openLocationSettings();
            },
          ),
        ),
      );
  }

  void _showLocationPermissionMessage({bool isPermanentlyDenied = false}) {
    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          content: Text(l10n.locationPermissionRequired),
          action: SnackBarAction(
            label: l10n.openSettings,
            textColor: Colors.white,
            onPressed: () async {
              if (isPermanentlyDenied) {
                await Geolocator.openAppSettings();
              } else {
                final opened =
                    await Geolocator.openLocationSettings();

                if (!opened) {
                  await Geolocator.openAppSettings();
                }
              }
            },
          ),
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
