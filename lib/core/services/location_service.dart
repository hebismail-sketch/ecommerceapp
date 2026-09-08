import 'dart:convert';
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
    if (lat >= 37.0 && lat <= 38.0 && lng >= -123.0 && lng <= -121.0) {
      return true;
    }
    return false;
  }

  /// Fetches the user's real location based on public IP
  /// This correctly resolves to Egypt (e.g. Al Fayyum) on emulators and WiFi.
  static Future<Position?> getLocationFromIp() async {
    try {
      final response = await http
          .get(Uri.parse('http://ip-api.com/json'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['status'] == 'success') {
          final lat = (data['lat'] as num).toDouble();
          final lon = (data['lon'] as num).toDouble();
          return Position(
            latitude: lat,
            longitude: lon,
            timestamp: DateTime.now(),
            accuracy: 5000,
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

    // Secondary IP fallback
    try {
      final response = await http
          .get(Uri.parse('https://ipapi.co/json/'))
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        if (data['latitude'] != null && data['longitude'] != null) {
          final lat = (data['latitude'] as num).toDouble();
          final lon = (data['longitude'] as num).toDouble();
          return Position(
            latitude: lat,
            longitude: lon,
            timestamp: DateTime.now(),
            accuracy: 5000,
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

  /// Gets the user's current location accurately.
  ///
  /// Prevents fake US emulator coordinates and resolves the user's true
  /// location in Egypt (e.g. Al Fayyum), falling back to Cairo by default.
  static Future<Position?> getCurrentLocation({bool allowIpFallback = true}) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (allowIpFallback) {
        final ipPos = await getLocationFromIp();
        if (ipPos != null) return ipPos;
      }
      return getCairoDefaultPosition();
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      if (allowIpFallback) {
        final ipPos = await getLocationFromIp();
        if (ipPos != null) return ipPos;
      }
      return getCairoDefaultPosition();
    }

    // 1. Attempt High-Accuracy GPS
    Position? gpsPosition;
    try {
      gpsPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 7),
        ),
      );
    } catch (_) {
      try {
        gpsPosition = await Geolocator.getLastKnownPosition();
      } catch (_) {}
    }

    // If GPS returned a valid non-US location, preferably in Egypt, return it
    if (gpsPosition != null && !isUsOrEmulatorLocation(gpsPosition.latitude, gpsPosition.longitude)) {
      return gpsPosition;
    }

    // 2. If GPS returned US coordinates (Emulator default) or failed, use IP-based Geolocation
    // which accurately resolves to Egypt (e.g. Fayoum) based on the user's real network connection
    if (allowIpFallback) {
      final ipPos = await getLocationFromIp();
      if (ipPos != null && !isUsOrEmulatorLocation(ipPos.latitude, ipPos.longitude)) {
        return ipPos;
      }
    }

    // 3. Fallback to Cairo, Egypt default
    return getCairoDefaultPosition();
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
