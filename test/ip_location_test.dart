import 'package:ecommerceapp/core/services/location_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LocationService has valid default coordinates', () {
    expect(LocationService.defaultLatitude, isNotNull);
    expect(LocationService.defaultLongitude, isNotNull);
  });
}
