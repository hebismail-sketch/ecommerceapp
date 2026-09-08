import 'package:ecommerceapp/core/theme/app_theme.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('AppTheme creates light theme without issues', () {
    final theme = AppTheme.lightTheme;
    expect(theme.useMaterial3, isTrue);
  });
}
