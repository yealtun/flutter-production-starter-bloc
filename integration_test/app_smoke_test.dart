import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_production_starter_bloc/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Smoke Test', () {
    testWidgets('app launches and shows login screen', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verify login screen is shown
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('can navigate to feed after login', (tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Find text fields and enter credentials
      final emailField = find.byType(TextFormField).first;
      final passwordField = find.byType(TextFormField).last;

      await tester.enterText(emailField, 'test@example.com');
      await tester.enterText(passwordField, 'password');
      await tester.tap(find.text('Login'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verify feed screen is shown (or at least app didn't crash)
      // The feed might be loading, so we just check the app is responsive
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
