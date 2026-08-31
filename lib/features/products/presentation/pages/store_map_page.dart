// File: lib/features/products/presentation/pages/store_map_page.dart

import 'package:ecommerceapp/core/services/location_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class StoreMapPage extends StatefulWidget {
  final String storeName;
  final double storeLatitude;
  final double storeLongitude;

  const StoreMapPage({
    super.key,
    required this.storeName,
    required this.storeLatitude,
    required this.storeLongitude,
  });

  static const String screenRoute = 'storeMap';

  @override
  State<StoreMapPage> createState() => _StoreMapPageState();
}

class _StoreMapPageState extends State<StoreMapPage> {
  final MapController _mapController = MapController();
  Position? _userPosition;
  bool _isLoadingUserLocation = true;
  double? _distanceKm;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    final pos = await LocationService.getCurrentLocation();
    if (pos != null) {
      final dist = LocationService.calculateDistanceInKm(
        startLatitude: pos.latitude,
        startLongitude: pos.longitude,
        endLatitude: widget.storeLatitude,
        endLongitude: widget.storeLongitude,
      );
      setState(() {
        _userPosition = pos;
        _distanceKm = dist;
        _isLoadingUserLocation = false;
      });
    } else {
      setState(() {
        _isLoadingUserLocation = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final storeLocation = LatLng(widget.storeLatitude, widget.storeLongitude);
    final userLocation = _userPosition != null
        ? LatLng(_userPosition!.latitude, _userPosition!.longitude)
        : null;

    final markers = <Marker>[
      // Store Marker
      Marker(
        point: storeLocation,
        width: 60,
        height: 60,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.red.shade700,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.storeName.isNotEmpty ? widget.storeName : 'المتجر',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(
              Icons.location_on,
              color: Colors.red,
              size: 32,
            ),
          ],
        ),
      ),
    ];

    if (userLocation != null) {
      // User Marker
      markers.add(
        Marker(
          point: userLocation,
          width: 50,
          height: 50,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.blue.shade700,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'موقعك',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(
                Icons.my_location,
                color: Colors.blue,
                size: 26,
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.storeName.isNotEmpty ? widget.storeName : 'موقع المتجر',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: storeLocation,
              initialZoom: 13.0,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.ecommerceapp',
              ),
              if (userLocation != null)
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: [userLocation, storeLocation],
                      strokeWidth: 4.0,
                      color: Colors.blue.shade600,
                      isDotted: true,
                    ),
                  ],
                ),
              MarkerLayer(markers: markers),
            ],
          ),

          // Bottom Info Card (Distance & Store Info)
          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.red.shade50,
                          child: Icon(Icons.store, color: Colors.red.shade700),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.storeName.isNotEmpty ? widget.storeName : 'متجر المنتج',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'الإحداثيات: ${widget.storeLatitude.toStringAsFixed(4)}, ${widget.storeLongitude.toStringAsFixed(4)}',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.directions_car, color: Colors.blue.shade700, size: 20),
                            const SizedBox(width: 6),
                            Text(
                              _isLoadingUserLocation
                                  ? 'جاري حساب المسافة...'
                                  : (_distanceKm != null
                                      ? 'المسافة: ${_distanceKm!.toStringAsFixed(2)} كم'
                                      : 'تعذر تحديد المسافة'),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.center_focus_strong, color: Colors.blue),
                          tooltip: 'التركيز على المتجر',
                          onPressed: () {
                            _mapController.move(storeLocation, 14.0);
                          },
                        ),
                      ],
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
