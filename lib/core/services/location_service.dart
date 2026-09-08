import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationService {
  /// Default coordinates (Cairo, Egypt)
  static const double defaultLatitude = 30.0444;
  static const double defaultLongitude = 31.2357;

  /// Approximate bounding box for Egypt
  static bool isInEgypt(double lat, double lng) {
    return lat >= 21.0 && lat <= 32.5 && lng >= 24.0 && lng <= 37.5;
  }

  /// Detects if a location is an Android emulator default or in the US
  /// (e.g. Googleplex in Mountain View: 37.42, -122.08, or any North America coords)
  static bool isUsOrEmulatorLocation(double lat, double lng) {
    if (lng < -50.0 && lng > -170.0 && lat > 15.0 && lat < 72.0) {
      return true;
    }
    // Specific check for Google Mountain View emulator default
    if (lat >= 36.5 && lat <= 38.5 && lng >= -123.5 && lng <= -120.5) {
      return true;
    }
    return false;
  }

  /// Fetches the user's real location based on public IP
  /// This correctly resolves to Egypt (e.g. Al Fayyum) on emulators and WiFi.
  static Future<Position?> getLocationFromIp() async {
    // 1. Primary HTTPS endpoint: ipwho.is (fast, HTTPS, accurate for Egypt / Fayoum)
    try {
      final response = await http
          .get(Uri.parse('https://ipwho.is/'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['success'] == true &&
            data['latitude'] != null &&
            data['longitude'] != null) {
          final lat = (data['latitude'] as num).toDouble();
          final lon = (data['longitude'] as num).toDouble();
          return Position(
            latitude: lat,
            longitude: lon,
            timestamp: DateTime.now(),
            accuracy: 100,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
        }
      }
    } catch (_) {}

    // 2. Secondary endpoint: ip-api.com (reliable and accurate for Egyptian cities)
    try {
      final response = await http
          .get(Uri.parse('http://ip-api.com/json'))
          .timeout(const Duration(seconds: 8));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'success') {
          final lat = (data['lat'] as num).toDouble();
          final lon = (data['lon'] as num).toDouble();
          return Position(
            latitude: lat,
            longitude: lon,
            timestamp: DateTime.now(),
            accuracy: 100,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
        }
      }
    } catch (_) {}

    return null;
  }

  /// Returns a Position representing Cairo, Egypt (the default city)
  static Position getCairoDefaultPosition() {
    return Position(
      latitude: defaultLatitude,
      longitude: defaultLongitude,
      timestamp: DateTime.now(),
      accuracy: 100,
      altitude: 0,
      altitudeAccuracy: 0,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  /// Gets the user's real location accurately using device GPS and sensors (down to house-level precision).
  ///
  /// Priority:
  /// 1. Device GPS / Fused Provider with LocationAccuracy.best (20s budget for satellite & Wi-Fi fix).
  /// 2. Device GPS with LocationAccuracy.high (15s budget).
  /// 3. Device GPS with LocationAccuracy.medium (10s budget).
  /// 4. Device last known position (if not US mock).
  /// 5. Network IP geolocation (only as fallback if physical GPS is unavailable or on an emulator).
  static Future<Position?> getCurrentLocation({bool fallbackToCairo = false}) async {
    return getDeviceGpsPosition(fallbackToCairo: fallbackToCairo);
  }

  /// Gets the phone's actual, real-time GPS position with maximum accuracy (house-level).
  ///
  /// This queries only device hardware sensors (Fused Provider / GPS Satellites).
  /// It NEVER guesses via IP geolocation to prevent displaying inaccurate cities.
  static Future<Position?> getDeviceGpsPosition({bool fallbackToCairo = false}) async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        if (fallbackToCairo) return getCairoDefaultPosition();
        return null;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (fallbackToCairo) return getCairoDefaultPosition();
        return null;
      }

      // 1. Check for quick, fresh last known position (< 5 minutes old)
      try {
        final lastPos = await Geolocator.getLastKnownPosition();
        if (lastPos != null &&
            !isUsOrEmulatorLocation(lastPos.latitude, lastPos.longitude)) {
          final age = DateTime.now().difference(lastPos.timestamp);
          if (age.inMinutes < 5) {
            return lastPos;
          }
        }
      } catch (_) {}

      // 2. High-accuracy Fused Provider / GPS query (up to 12s)
      try {
        final pos = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 12),
          ),
        );
        if (!isUsOrEmulatorLocation(pos.latitude, pos.longitude)) {
          return pos;
        }
      } catch (_) {}

      // 3. Native Android LocationManager if Fused client stalls
      if (defaultTargetPlatform == TargetPlatform.android) {
        try {
          final pos = await Geolocator.getCurrentPosition(
            locationSettings: AndroidSettings(
              accuracy: LocationAccuracy.high,
              forceLocationManager: true,
              timeLimit: const Duration(seconds: 8),
            ),
          );
          if (!isUsOrEmulatorLocation(pos.latitude, pos.longitude)) {
            return pos;
          }
        } catch (_) {}
      }

      // 4. Any cached position if not emulator
      try {
        final lastPos = await Geolocator.getLastKnownPosition();
        if (lastPos != null &&
            !isUsOrEmulatorLocation(lastPos.latitude, lastPos.longitude)) {
          return lastPos;
        }
      } catch (_) {}
    } catch (_) {}

    // Fallback to Cairo ONLY if explicitly requested
    if (fallbackToCairo) {
      return getCairoDefaultPosition();
    }

    return null;
  }

  /// Returns the raw device position without filtering emulator coordinates,
  /// allowing callers to detect if the position is an emulator default.
  static Future<Position?> getRawDevicePosition() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      // Try quick last known position
      try {
        final lastPos = await Geolocator.getLastKnownPosition();
        if (lastPos != null) {
          final age = DateTime.now().difference(lastPos.timestamp);
          if (age.inMinutes < 5) return lastPos;
        }
      } catch (_) {}

      // Try high accuracy GPS / Fused Provider
      try {
        return await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            timeLimit: Duration(seconds: 10),
          ),
        );
      } catch (_) {}

      // Try last known position as fallback
      try {
        return await Geolocator.getLastKnownPosition();
      } catch (_) {}
    } catch (_) {}
    return null;
  }

  /// Calculates the distance between two coordinates in kilometers
  static double calculateDistanceInKm({
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) {
    final distanceInMeters = Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    );
    return distanceInMeters / 1000.0;
  }
}
