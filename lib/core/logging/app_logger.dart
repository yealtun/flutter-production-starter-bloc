import 'package:logger/logger.dart';

/// Application logger wrapper with levels and request-id support
class AppLogger {
  AppLogger()
    : _logger = Logger(
        printer: PrettyPrinter(
          methodCount: 0,
          errorMethodCount: 8,
          lineLength: 120,
          colors: true,
          printEmojis: true,
          dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
        ),
      );

  final Logger _logger;

  /// Log a debug message
  void d(
    dynamic message, {
    String? requestId,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = requestId != null ? '[$requestId] ' : '';
    _logger.d('$prefix$message', error: error, stackTrace: stackTrace);
  }

  /// Log an info message
  void i(
    dynamic message, {
    String? requestId,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = requestId != null ? '[$requestId] ' : '';
    _logger.i('$prefix$message', error: error, stackTrace: stackTrace);
  }

  /// Log a warning message
  void w(
    dynamic message, {
    String? requestId,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = requestId != null ? '[$requestId] ' : '';
    _logger.w('$prefix$message', error: error, stackTrace: stackTrace);
  }

  /// Log an error message
  void e(
    dynamic message, {
    String? requestId,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = requestId != null ? '[$requestId] ' : '';
    _logger.e('$prefix$message', error: error, stackTrace: stackTrace);
  }

  /// Log a fatal error message
  void f(
    dynamic message, {
    String? requestId,
    dynamic error,
    StackTrace? stackTrace,
  }) {
    final prefix = requestId != null ? '[$requestId] ' : '';
    _logger.f('$prefix$message', error: error, stackTrace: stackTrace);
  }
}
