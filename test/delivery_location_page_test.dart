import 'package:ecommerceapp/core/services/location_service.dart';
import 'package:ecommerceapp/features/orders/presentation/pages/delivery_location_page.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('LocationService defaults to Cairo and filters US emulator locations', () {
    // Cairo default coordinates
    expect(LocationService.defaultLatitude, 30.0444);
    expect(LocationService.defaultLongitude, 31.2357);

    // Cairo is in Egypt
    expect(LocationService.isInEgypt(30.0444, 31.2357), isTrue);

  

    // US / Mountain View Android emulator mock location is flagged
    expect(LocationService.isUsOrEmulatorLocation(37.4219983, -122.084), isTrue);

    // Egypt locations are NOT US locations
    expect(LocationService.isUsOrEmulatorLocation(30.0444, 31.2357), isFalse);
    expect(LocationService.isUsOrEmulatorLocation(29.3082, 30.8446), isFalse);
  });

  testWidgets('DeliveryLocationPage renders search bar, GPS button and confirm button with Cairo default',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: DeliveryLocationPage(),
      ),
    );

    await tester.pumpAndSettle();

    // Verify search text field is present
    expect(find.byType(TextField), findsOneWidget);

    // Verify GPS button text badge is present beside search bar
    expect(find.text('GPS'), findsOneWidget);

    // Verify Confirm button is present
    expect(find.byIcon(Icons.check_circle_outline), findsOneWidget);

    // Verify GPS Floating action button is present
    expect(find.byType(FloatingActionButton), findsOneWidget);

    // Verify default Cairo coordinates are displayed
    expect(find.textContaining('30.04440'), findsOneWidget);
    expect(find.textContaining('31.23570'), findsOneWidget);
  });
}
