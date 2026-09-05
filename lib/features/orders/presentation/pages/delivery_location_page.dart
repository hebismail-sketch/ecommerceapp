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

  bool _isLocating = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();

    _selectedLocation = const LatLng(
      30.0444,
      31.2357,
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

      setState(() {
        _selectedLocation = location;
      });

      _mapController.move(location, 17);

      _showMessage(
        AppLocalizations.of(context)!.confirmLocation,
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

  Future<void> _useCurrentLocation() async {
    if (_isLocating) return;

    setState(() => _isLocating = true);

    try {
      final position = await LocationService.getCurrentLocation();

      if (!mounted) return;

      if (position == null) {
        _showLocationPermissionMessage();
        return;
      }

      final currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );

      setState(() {
        _selectedLocation = currentLocation;
      });

      _mapController.move(currentLocation, 17);
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

  void _showLocationPermissionMessage() {
    final l10n = AppLocalizations.of(context)!;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.red,
        content: Text(l10n.locationPermissionRequired),
        action: SnackBarAction(
          label: l10n.openSettings,
          textColor: Colors.white,
          onPressed: () async {
            final opened =
                await Geolocator.openLocationSettings();

            if (!opened) {
              await Geolocator.openAppSettings();
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
          backgroundColor: isError ? Colors.red : Colors.green,
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
                  suffixIcon: IconButton(
                    tooltip: l10n.search,
                    onPressed:
                        _isSearching ? null : _searchLocation,
                    icon: const Icon(Icons.arrow_forward),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            top: 78,
            left: 16,
            right: 16,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(
                      Icons.touch_app,
                      color: Colors.blue.shade700,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.tapMapToSelectLocation,
                        style: const TextStyle(fontSize: 13),
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
              backgroundColor: Colors.white,
              foregroundColor: Colors.blue.shade700,
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
                      children: [
                        const Icon(
                          Icons.pin_drop,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${l10n.selectedLocation}: '
                            '${_selectedLocation.latitude.toStringAsFixed(5)}, '
                            '${_selectedLocation.longitude.toStringAsFixed(5)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: _confirmLocation,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(
                          l10n.confirmLocation,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
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
