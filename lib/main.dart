import 'package:flutter/material.dart';
import 'core/di/injector.dart';
import 'core/logging/app_logger.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI
  try {
    await initInjector();
  } catch (e) {
    // Log error but continue - DI errors should be caught during development
    debugPrint('Error initializing DI: $e');
  }

  // Set up error handling
  FlutterError.onError = (details) {
    final logger = getIt<AppLogger>();
    logger.e(
      'Flutter Error',
      error: details.exception,
      stackTrace: details.stack,
    );
    FlutterError.presentError(details);
  };

  runApp(const App());
}
