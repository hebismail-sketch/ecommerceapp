import 'package:geolocator/geolocator.dart';

class LocationService {
  /// Gets a location quickly without waiting forever for a GPS fix.
  ///
  /// Medium accuracy uses the emulator/network provider when available and is
  /// more than enough for choosing a store location. If a fresh fix is not
  /// available, a cached position is returned instead of leaving the UI stuck.
  static Future<Position?> getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          timeLimit: Duration(seconds: 8),
        ),
      );
    } catch (_) {
      // A cold GPS start can take longer on a real device or emulator. A
      // cached position is still useful and prevents the screen from hanging.
      return Geolocator.getLastKnownPosition();
    }
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
