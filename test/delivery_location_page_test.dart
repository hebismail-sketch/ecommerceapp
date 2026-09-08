import 'package:ecommerceapp/features/orders/presentation/pages/delivery_location_page.dart';
import 'package:ecommerceapp/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('DeliveryLocationPage renders search bar, GPS button and confirm button',
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
    expect(find.byKey(const ValueKey('delivery_gps_fab')), findsNothing); // heroTag used
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });
}
